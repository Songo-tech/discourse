import Component from "@ember/component";
import { action } from "@ember/object";
import { alias } from "@ember/object/computed";
import { isEmpty } from "@ember/utils";
import DTextarea from "discourse/components/d-textarea";
import ShareSource from "discourse/components/share-source";
import htmlSafe from "discourse/helpers/html-safe";
import i18n0 from "discourse/helpers/i18n";
import discourseComputed from "discourse/lib/decorators";
import discourseLater from "discourse/lib/later";
import Sharing from "discourse/lib/sharing";
import { escapeExpression } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

export default class SharePanel extends Component {
  tagName = null;

  @alias("panel.model.type") type;
  @alias("panel.model.topic") topic;
  @alias("panel.model.topic.category.read_restricted") privateCategory;

  @discourseComputed("topic.{isPrivateMessage,invisible,category}")
  sources(topic) {
    const privateContext =
      this.siteSettings.login_required ||
      (topic && topic.isPrivateMessage) ||
      (topic && topic.invisible) ||
      this.privateCategory;
    return Sharing.activeSources(this.siteSettings.share_links, privateContext);
  }

  @discourseComputed("type", "topic.title")
  shareTitle(type, topicTitle) {
    topicTitle = escapeExpression(topicTitle);
    return i18n("share.topic_html", { topicTitle });
  }

  @discourseComputed("panel.model.shareUrl", "topic.shareUrl")
  shareUrl(forcedShareUrl, shareUrl) {
    shareUrl = forcedShareUrl || shareUrl;

    if (isEmpty(shareUrl)) {
      return;
    }

    // Relative urls
    if (shareUrl.startsWith("/")) {
      const location = window.location;
      shareUrl = `${location.protocol}//${location.host}${shareUrl}`;
    }

    return encodeURI(shareUrl);
  }

  didInsertElement() {
    super.didInsertElement(...arguments);
    discourseLater(() => {
      if (this.element) {
        const textArea = this.element.querySelector(".topic-share-url");
        textArea.style.height = textArea.scrollHeight + "px";
        textArea.focus();
        textArea.setSelectionRange(0, this.shareUrl.length);
      }
    }, 200);
  }

  @action
  share(source) {
    Sharing.shareSource(source, {
      url: this.shareUrl,
      title: this.topic.get("title"),
    });
  }

  <template>
    <div class="header">
      <h3 class="title">{{htmlSafe this.shareTitle}}</h3>
    </div>

    <div class="body">
      <DTextarea
        @value={{this.shareUrl}}
        @aria-label={{i18n0 "share.url"}}
        class="topic-share-url"
      />

      <div class="sources">
        {{#each this.sources as |source|}}
          <ShareSource @source={{source}} @action={{this.share}} />
        {{/each}}
      </div>
    </div>
  </template>
}
