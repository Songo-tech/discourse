import RouteTemplate from 'ember-route-template'
import i18n from "discourse/helpers/i18n";
import PluginOutlet from "discourse/components/plugin-outlet";
import EmptyState from "discourse/components/empty-state";
import NotificationsFilter from "select-kit/components/notifications-filter";
import { hash } from "@ember/helper";
import MenuItem from "discourse/components/user-menu/menu-item";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
export default RouteTemplate(<template>{{#if @controller.model.error}}
  <div class="item error">
    {{#if @controller.model.forbidden}}
      {{i18n "errors.reasons.forbidden"}}
    {{else}}
      {{i18n "errors.desc.unknown"}}
    {{/if}}
  </div>
{{else if @controller.doesNotHaveNotifications}}
  <PluginOutlet @name="user-notifications-empty-state">
    <EmptyState @title={{i18n "user.no_notifications_page_title"}} @body={{@controller.emptyStateBody}} />
  </PluginOutlet>
{{else}}
  <PluginOutlet @name="user-notifications-above-filter" />
  <div class="user-notifications-filter">
    <NotificationsFilter @value={{@controller.filter}} @onChange={{@controller.updateFilter}} />
    <PluginOutlet @name="user-notifications-after-filter" @outletArgs={{hash items=@controller.items}} />
  </div>

  {{#if @controller.nothingFound}}
    <div class="alert alert-info">{{i18n "notifications.empty"}}</div>
  {{else}}
    <div class={{@controller.listContainerClassNames}}>
      {{#each @controller.items as |item|}}
        <MenuItem @item={{item}} />
      {{/each}}
      <ConditionalLoadingSpinner @condition={{@controller.loading}} />
      <PluginOutlet @name="user-notifications-list-bottom" @outletArgs={{hash controller=@controller}} />
    </div>
  {{/if}}
{{/if}}</template>)