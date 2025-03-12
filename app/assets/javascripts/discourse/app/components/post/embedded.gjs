import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import DecoratedHtml from "discourse/components/decorated-html";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import PostAvatar from "./avatar";
import PostMetaDataPosterName from "./meta-data/poster-name";
import PostCookedHtml from "./cooked-html";

export default class PostEmbedded extends Component {
  @service appEvents;

  <template>
    <div ...attributes class="reply" data-post-id={{@post.id}}>
      <PostAvatar @post={{@post}} />
      <div class="row">
        <div class="topic-body">
          <div class="topic-meta-data embedded-reply">
            <PostMetaDataPosterName @post={{@post}} />
            <div class="post-link-arrow">
              <a
                class="post-info arrow"
                aria-label={{i18n
                  "topic.jump_reply_aria"
                  username=@post.username
                }}
                href={{@post.shareUrl}}
                title={{i18n "topic.jump_reply"}}
              >
                {{#if @above}}
                  {{icon "arrow-up"}}
                {{else}}
                  {{icon "arrow-down"}}
                {{/if}}
                {{i18n "topic.jump_reply_button"}}
              </a>
            </div>
          </div>
          <PostCookedHtml
            @post={{@post}}
            @highlightTerm={{@highlightTerm}}
            @streamElement={{false}}
          />
        </div>
      </div>
    </div>
  </template>
}
