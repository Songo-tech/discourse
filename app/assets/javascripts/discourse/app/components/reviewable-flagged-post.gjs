import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { bind } from "discourse/lib/decorators";

export default class ReviewableFlaggedPost extends Component {
  @tracked isCollapsed = false;
  @tracked isLongPost = false;
  maxPostHeight = 300;

  @action
  toggleContent() {
    this.isCollapsed = !this.isCollapsed;
  }

  @bind
  calculatePostBodySize(element) {
    if (element?.offsetHeight > this.maxPostHeight) {
      this.isCollapsed = true;
      this.isLongPost = true;
    } else {
      this.isCollapsed = false;
      this.isLongPost = false;
    }
  }

  get collapseButtonProps() {
    if (this.isCollapsed) {
      return {
        label: "review.show_more",
        icon: "chevron-down",
      };
    }
    return {
      label: "review.show_less",
      icon: "chevron-up",
    };
  }
}
<div class="flagged-post-header">
  <ReviewableTopicLink @reviewable={{@reviewable}} @tagName="" />
  <ReviewablePostEdits @reviewable={{@reviewable}} @tagName="" />
</div>

<div class="post-contents-wrapper">
  <ReviewableCreatedBy @user={{@reviewable.target_created_by}} />
  <div class="post-contents">
    <ReviewablePostHeader
      @reviewable={{@reviewable}}
      @createdBy={{@reviewable.target_created_by}}
      @tagName=""
    />
    <div
      class="post-body {{if this.isCollapsed 'is-collapsed'}}"
      {{did-insert this.calculatePostBodySize @reviewable}}
    >
      {{#if @reviewable.blank_post}}
        <p>{{i18n "review.deleted_post"}}</p>
      {{else}}
        {{html-safe @reviewable.cooked}}
      {{/if}}
    </div>

    {{#if this.isLongPost}}
      <DButton
        @action={{this.toggleContent}}
        @label={{this.collapseButtonProps.label}}
        @icon={{this.collapseButtonProps.icon}}
        class="btn-default btn-icon post-body__toggle-btn"
      />
    {{/if}}
    <span>
      <PluginOutlet
        @name="after-reviewable-flagged-post-body"
        @connectorTagName="div"
        @outletArgs={{hash model=@reviewable}}
      />
    </span>
    {{yield}}
  </div>
</div>