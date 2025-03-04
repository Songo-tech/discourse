import RouteTemplate from 'ember-route-template'
import bodyClass from "discourse/helpers/body-class";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import PluginOutlet from "discourse/components/plugin-outlet";
import iN from "discourse/helpers/i18n";
import EmptyState from "discourse/components/empty-state";
import { Input } from "@ember/component";
import DButton from "discourse/components/d-button";
import BookmarkList from "discourse/components/bookmark-list";
export default RouteTemplate(<template>{{bodyClass "user-activity-bookmarks-page"}}

<ConditionalLoadingSpinner @condition={{@controller.loading}}>
  <PluginOutlet @name="above-user-bookmarks" @connectorTagName="div" />

  {{#if @controller.permissionDenied}}
    <div class="alert alert-info">{{iN "bookmarks.list_permission_denied"}}</div>
  {{else if @controller.userDoesNotHaveBookmarks}}
    <EmptyState @title={{iN "user.no_bookmarks_title"}} @body={{@controller.emptyStateBody}} />
  {{else}}
    <div class="inline-form full-width bookmark-search-form">
      <Input @type="text" @value={{@controller.searchTerm}} placeholder={{iN "bookmarks.search_placeholder"}} @enter={{@controller.search}} id="bookmark-search" autocomplete="off" />
      <DButton @action={{@controller.search}} @icon="magnifying-glass" class="btn-primary" />
    </div>
    {{#if @controller.nothingFound}}
      <div class="alert alert-info">{{iN "user.no_bookmarks_search"}}</div>
    {{else}}
      <BookmarkList @bulkSelectHelper={{@controller.bulkSelectHelper}} @loadMore={{action "loadMore"}} @reload={{action "reload"}} @loadingMore={{@controller.loadingMore}} @content={{@controller.model.bookmarks}} />
    {{/if}}
  {{/if}}
</ConditionalLoadingSpinner></template>)