import RouteTemplate from 'ember-route-template'
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import i18n from "discourse/helpers/i18n";
import icon from "discourse/helpers/d-icon";
import TagChooser from "select-kit/components/tag-chooser";
import GroupManageSaveButton from "discourse/components/group-manage-save-button";
export default RouteTemplate(<template><form class="groups-form form-vertical groups-notifications-form">

  <PluginOutlet @name="before-manage-group-tags" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />

  <div class="control-group">
    <label class="control-label">{{i18n "groups.manage.tags.long_title"}}</label>
    <div>{{i18n "groups.manage.tags.description"}}</div>
  </div>

  <div class="control-group">
    <label>{{icon "d-watching"}}
      {{i18n "groups.notifications.watching.title"}}</label>

    <TagChooser @tags={{@controller.model.watching_tags}} @blockedTags={{@controller.selectedTags}} @everyTag={{true}} @unlimitedTagCount={{true}} @options={{hash allowAny=false}} />

    <div class="control-instructions">
      {{i18n "groups.manage.tags.watched_tags_instructions"}}
    </div>
  </div>

  <div class="control-group">
    <label>{{icon "d-tracking"}}
      {{i18n "groups.notifications.tracking.title"}}</label>

    <TagChooser @tags={{@controller.model.tracking_tags}} @blockedTags={{@controller.selectedTags}} @everyTag={{true}} @unlimitedTagCount={{true}} @options={{hash allowAny=false}} />

    <div class="control-instructions">
      {{i18n "groups.manage.tags.tracked_tags_instructions"}}
    </div>
  </div>

  <div class="control-group">
    <label>{{icon "d-watching-first"}}
      {{i18n "groups.notifications.watching_first_post.title"}}</label>

    <TagChooser @tags={{@controller.model.watching_first_post_tags}} @blockedTags={{@controller.selectedTags}} @everyTag={{true}} @unlimitedTagCount={{true}} @options={{hash allowAny=false}} />

    <div class="control-instructions">
      {{i18n "groups.manage.tags.watching_first_post_tags_instructions"}}
    </div>
  </div>

  <div class="control-group">
    <label>{{icon "d-regular"}}
      {{i18n "groups.notifications.regular.title"}}</label>

    <TagChooser @tags={{@controller.model.regular_tags}} @blockedTags={{@controller.selectedTags}} @everyTag={{true}} @unlimitedTagCount={{true}} @options={{hash allowAny=false}} />

    <div class="control-instructions">
      {{i18n "groups.manage.tags.regular_tags_instructions"}}
    </div>
  </div>

  <div class="control-group">
    <label>{{icon "d-muted"}}
      {{i18n "groups.notifications.muted.title"}}</label>

    <TagChooser @tags={{@controller.model.muted_tags}} @blockedTags={{@controller.selectedTags}} @everyTag={{true}} @unlimitedTagCount={{true}} @options={{hash allowAny=false}} />

    <div class="control-instructions">
      {{i18n "groups.manage.tags.muted_tags_instructions"}}
    </div>
  </div>

  <GroupManageSaveButton @model={{@controller.model}} />
</form></template>)