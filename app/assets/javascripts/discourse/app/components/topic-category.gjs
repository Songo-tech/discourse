import Component from "@ember/component";
import { hash } from "@ember/helper";
import PluginOutlet from "discourse/components/plugin-outlet";
// Injections don't occur without a class
import boundCategoryLink from "discourse/helpers/bound-category-link";
import discourseTags from "discourse/helpers/discourse-tags";
import topicFeaturedLink from "discourse/helpers/topic-featured-link";
export default class TopicCategory extends Component {
  <template>
    {{#unless this.topic.isPrivateMessage}}
      {{boundCategoryLink
        this.topic.category
        ancestors=this.topic.category.predecessors
        hideParent=true
      }}
    {{/unless}}
    <div class="topic-header-extra">
      {{#if this.siteSettings.tagging_enabled}}
        <div class="list-tags">
          {{discourseTags this.topic mode="list" tags=this.topic.tags}}
        </div>
      {{/if}}
      {{#if this.siteSettings.topic_featured_link_enabled}}
        {{topicFeaturedLink this.topic}}
      {{/if}}
    </div>

    <span>
      <PluginOutlet
        @name="topic-category"
        @connectorTagName="div"
        @outletArgs={{hash topic=this.topic category=this.topic.category}}
      />
    </span>
  </template>
}
