import RouteTemplate from 'ember-route-template'
import i18n from "discourse/helpers/i18n";
import ComboBox from "select-kit/components/combo-box";
import DesktopNotificationConfig from "discourse/components/desktop-notification-config";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import UserNotificationSchedule from "discourse/components/user-notification-schedule";
import SaveControls from "discourse/components/save-controls";
export default RouteTemplate(<template><div class="control-group notifications">
  <label class="control-label">{{i18n "user.notifications"}}</label>

  <div class="controls controls-dropdown" data-setting-name="user-like-notification-frequency">
    <label>{{i18n "user.like_notification_frequency.title"}}</label>
    <ComboBox @valueProperty="value" @content={{@controller.likeNotificationFrequencies}} @value={{@controller.model.user_option.like_notification_frequency}} @onChange={{action (mut @controller.model.user_option.like_notification_frequency)}} />
  </div>
</div>

{{#unless @controller.capabilities.isAppWebview}}
  <div class="control-group desktop-notifications" data-setting-name="user-desktop-notifications">
    <label class="control-label">{{i18n "user.desktop_notifications.label"}}</label>
    <DesktopNotificationConfig />
    <div class="instructions">{{i18n "user.desktop_notifications.each_browser_note"}}</div>
    <span>
      <PluginOutlet @name="user-preferences-desktop-notifications" @connectorTagName="div" @outletArgs={{hash model=@controller.model save=(action "save")}} />
    </span>
  </div>
{{/unless}}

<UserNotificationSchedule @model={{@controller.model}} />

<span>
  <PluginOutlet @name="user-preferences-notifications" @connectorTagName="div" @outletArgs={{hash model=@controller.model save=(action "save")}} />
</span>

<br />

<span>
  <PluginOutlet @name="user-custom-controls" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
</span>

<SaveControls @model={{@controller.model}} @action={{action "save"}} @saved={{@controller.saved}} /></template>)