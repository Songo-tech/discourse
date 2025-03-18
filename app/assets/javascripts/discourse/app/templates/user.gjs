import RouteTemplate from 'ember-route-template'
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash, array, fn, concat } from "@ember/helper";
import i18n from "discourse/helpers/i18n";
import htmlSafe from "discourse/helpers/html-safe";
import { LinkTo } from "@ember/routing";
import { on } from "@ember/modifier";
import UserProfileAvatar from "discourse/components/user-profile-avatar";
import formatUsername from "discourse/helpers/format-username";
import userStatus from "discourse/helpers/user-status";
import UserStatusMessage from "discourse/components/user-status-message";
import icon from "discourse/helpers/d-icon";
import replaceEmoji from "discourse/helpers/replace-emoji";
import HtmlWithLinks from "discourse/components/html-with-links";
import DButton from "discourse/components/d-button";
import routeAction from "discourse/helpers/route-action";
import UserNotificationsDropdown from "select-kit/components/user-notifications-dropdown";
import boundDate from "discourse/helpers/bound-date";
import UserNav from "discourse/components/user-nav";
export default RouteTemplate(<template><PluginOutlet @name="above-user-profile" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
<div class="container
    {{if @controller.viewingSelf "viewing-self"}}
    {{if @controller.model.profile_hidden "profile-hidden"}}
    {{@controller.primaryGroup}}">
  <section class="user-main">
    <a href="#user-content" id="user-nav-skip-link" class="skip-link__user-nav">
      {{i18n "skip_user_nav"}}
    </a>
    <section class="{{if @controller.collapsedInfo "collapsed-info"}}
        about
        {{if @controller.hasProfileBackgroundUrl "has-background" "no-background"}}">
      {{#unless @controller.collapsedInfo}}
        {{#if @controller.showStaffCounters}}
          <div class="staff-counters">
            {{#if @controller.model.number_of_flags_given}}
              <div>
                {{htmlSafe (i18n "user.staff_counters.flags_given" className="helpful-flags" count=@controller.model.number_of_flags_given)}}
              </div>
            {{/if}}
            {{#if @controller.model.number_of_flagged_posts}}
              <div>
                <LinkTo @route="review" @query={{hash username=@controller.model.username status="all" type="ReviewableFlaggedPost"}}>
                  {{htmlSafe (i18n "user.staff_counters.flagged_posts" className="flagged-posts" count=@controller.model.number_of_flagged_posts)}}
                </LinkTo>
              </div>
            {{/if}}
            {{#if @controller.model.number_of_rejected_posts}}
              <div>
                <LinkTo @route="review" @query={{hash username=@controller.model.username status="rejected" type="ReviewableQueuedPost"}}>
                  {{htmlSafe (i18n "user.staff_counters.rejected_posts" className="flagged-posts" count=@controller.model.number_of_rejected_posts)}}
                </LinkTo>
              </div>
            {{/if}}

            {{#if @controller.model.number_of_deleted_posts}}
              <div>
                <LinkTo @route="user.deletedPosts" @model={{@controller.model}}>
                  {{htmlSafe (i18n "user.staff_counters.deleted_posts" className="deleted-posts" count=@controller.model.number_of_deleted_posts)}}
                </LinkTo>
              </div>
            {{/if}}
            {{#if @controller.model.number_of_suspensions}}
              <div>
                <a href {{on "click" @controller.showSuspensions}}>
                  {{htmlSafe (i18n "user.staff_counters.suspensions" className="suspensions" count=@controller.model.number_of_suspensions)}}
                </a>
              </div>
            {{/if}}
            {{#if @controller.model.warnings_received_count}}
              <div>
                <LinkTo @route="userPrivateMessages.user.warnings" @model={{@controller.model}}>
                  {{htmlSafe (i18n "user.staff_counters.warnings_received" className="warnings-received" count=@controller.model.warnings_received_count)}}
                </LinkTo>
              </div>
            {{/if}}
          </div>
        {{/if}}
        <div class="user-profile-image" style={{@controller.model.profileBackgroundUrl}}></div>
      {{/unless}}
      <div class="details">
        <div class="primary">
          <PluginOutlet @name="before-user-profile-avatar" @outletArgs={{hash model=@controller.model}} />
          <UserProfileAvatar @user={{@controller.model}} @tagName />
          <div class="primary-textual">
            <div class="user-profile-names">
              <div class="{{if @controller.nameFirst "full-name" "username"}}
                  user-profile-names__primary">
                {{if @controller.nameFirst @controller.model.name (formatUsername @controller.model.username)}}
                {{userStatus @controller.model currentUser=@controller.currentUser}}
                {{#if @controller.model.status}}
                  <UserStatusMessage @status={{@controller.model.status}} />
                {{/if}}
              </div>
              <div class="{{if @controller.nameFirst "username" "full-name"}}
                  user-profile-names__secondary">{{#if @controller.nameFirst}}{{@controller.model.username}}{{else}}{{@controller.model.name}}{{/if}}</div>
              {{#if @controller.model.staged}}
                <div class="staged user-profile-names__secondary">{{i18n "user.staged"}}</div>
              {{/if}}
              {{#if @controller.model.title}}
                <div class="user-profile-names__title">{{@controller.model.title}}</div>
              {{/if}}
              <span>
                <PluginOutlet @name="user-post-names" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
              </span>
            </div>

            {{#if @controller.showFeaturedTopic}}
              <div class="featured-topic user-profile__featured-topic">
                <span title={{i18n "user.featured_topic"}}>
                  {{icon "book"~}}
                </span><LinkTo @route="topic" @models={{array @controller.model.featured_topic.slug @controller.model.featured_topic.id}}>{{replaceEmoji (htmlSafe @controller.model.featured_topic.fancy_title)}}</LinkTo>
              </div>
            {{/if}}

            <div class="location-and-website user-profile__location-and-website">
              {{#if @controller.model.location}}<div class="user-profile-location">{{icon "location-dot"~}}
                  {{@controller.model.location}}</div>{{/if}}
              {{#if @controller.model.website_name}}
                <div class="user-profile-website">
                  {{!-- template-lint-disable link-rel-noopener --}}
                  {{icon "globe"~}}
                  {{#if @controller.linkWebsite~}}
                    <a href={{@controller.model.website}} rel="noopener {{unless @controller.removeNoFollow "nofollow ugc"}}" target="_blank">{{@controller.model.website_name}}</a>
                  {{else}}
                    <span title={{@controller.model.website}}>{{@controller.model.website_name}}</span>
                  {{/if}}
                  {{!-- template-lint-enable link-rel-noopener --}}
                </div>
              {{/if}}
              <span>
                <PluginOutlet @name="user-location-and-website" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
              </span>
            </div>

            <div class="bio">
              {{#if @controller.model.suspended}}
                <div class="suspended">
                  {{icon "ban"}}
                  <b>
                    {{#if @controller.model.suspendedForever}}
                      {{i18n "user.suspended_permanently"}}
                    {{else}}
                      {{i18n "user.suspended_notice" date=@controller.model.suspendedTillDate}}
                    {{/if}}
                  </b>
                  <br />
                  {{#if @controller.model.suspend_reason}}
                    <b>{{i18n "user.suspended_reason"}}</b>
                    {{@controller.model.suspend_reason}}
                  {{/if}}
                </div>
              {{/if}}
              {{#if @controller.isNotSuspendedOrIsStaff}}
                <HtmlWithLinks>
                  {{htmlSafe @controller.model.bio_cooked}}
                </HtmlWithLinks>
              {{/if}}
            </div>

            {{#if @controller.publicUserFields}}
              <div class="public-user-fields">
                {{#each @controller.publicUserFields as |uf|}}
                  {{#if uf.value}}
                    <div class="public-user-field {{uf.field.dasherized_name}}">
                      <span class="user-field-name">{{uf.field.name}}</span>:
                      <span class="user-field-value">
                        {{#each uf.value as |v|}}
                          {{!-- some values are arrays --}}
                          <span class="user-field-value-list-item">
                            {{#if uf.field.searchable}}
                              <LinkTo @route="users" @query={{hash name=v}}>{{v}}</LinkTo>
                            {{else}}
                              {{v}}
                            {{/if}}
                          </span>
                        {{else}}
                          {{uf.value}}
                        {{/each}}
                      </span>
                    </div>
                  {{/if}}
                {{/each}}

                <span>
                  <PluginOutlet @name="user-profile-public-fields" @connectorTagName="div" @outletArgs={{hash publicUserFields=@controller.publicUserFields model=@controller.model}} />
                </span>
              </div>
            {{/if}}

            <span>
              <PluginOutlet @name="user-profile-primary" @connectorTagName="div" @outletArgs={{hash model=@controller.model}} />
            </span>
          </div>

          <section class="controls">
            <ul>
              {{#if @controller.model.can_send_private_message_to_user}}
                <li>
                  <DButton @action={{fn (routeAction "composePrivateMessage") @controller.model}} @icon="envelope" @label="user.private_message" class="btn-primary compose-pm" />
                </li>
              {{/if}}

              {{#if @controller.canMuteOrIgnoreUser}}
                <li>
                  <UserNotificationsDropdown @user={{@controller.model}} @value={{@controller.userNotificationLevel}} @updateNotificationLevel={{action "updateNotificationLevel"}} />
                </li>
              {{/if}}

              {{#if @controller.displayTopLevelAdminButton}}
                <li><a href={{@controller.model.adminPath}} class="btn btn-default user-admin">{{icon "wrench"}}<span class="d-button-label">{{i18n "admin.user.show_admin_profile"}}</span></a></li>
              {{/if}}

              <PluginOutlet @name="user-profile-controls" @connectorTagName="li" @outletArgs={{hash model=@controller.model}} />

              {{#if @controller.canExpandProfile}}
                <li>
                  <DButton @ariaLabel={{@controller.collapsedInfoState.ariaLabel}} @label={{concat "user." @controller.collapsedInfoState.label}} @icon={{@controller.collapsedInfoState.icon}} @action={{action @controller.collapsedInfoState.action}} aria-controls="collapsed-info-panel" aria-expanded={{if @controller.collapsedInfoState.isExpanded "true" "false"}} class="btn-default" />
                </li>
              {{/if}}
            </ul>
          </section>
        </div>
        <PluginOutlet @name="user-profile-above-collapsed-info" @outletArgs={{hash model=@controller.model collapsedInfo=@controller.collapsedInfo}} />
        {{#unless @controller.collapsedInfo}}
          <div class="secondary" id="collapsed-info-panel">
            <dl>
              {{#if @controller.model.created_at}}
                <div><dt class="created-at">{{i18n "user.created"}}</dt><dd class="created-at">{{boundDate @controller.model.created_at}}</dd></div>
              {{/if}}
              {{#if @controller.model.last_posted_at}}
                <div><dt class="last-posted-at">{{i18n "user.last_posted"}}</dt><dd class="last-posted-at">{{boundDate @controller.model.last_posted_at}}</dd></div>
              {{/if}}
              {{#if @controller.model.last_seen_at}}
                <div><dt class="last-seen-at">{{i18n "user.last_seen"}}</dt><dd class="last-seen-at">{{boundDate @controller.model.last_seen_at}}</dd></div>
              {{/if}}
              {{#if @controller.model.profile_view_count}}
                <div><dt class="profile-view-count">{{i18n "views"}}</dt><dd class="profile-view-count">{{@controller.model.profile_view_count}}</dd></div>
              {{/if}}
              {{#if @controller.model.invited_by}}
                <div><dt class="invited-by">{{i18n "user.invited_by"}}</dt><dd class="invited-by"><LinkTo @route="user" @model={{@controller.model.invited_by}}>{{@controller.model.invited_by.username}}</LinkTo></dd></div>
              {{/if}}
              {{#if @controller.hasTrustLevel}}
                <div><dt class="trust-level">{{i18n "user.trust_level"}}</dt><dd class="trust-level">{{@controller.model.trustLevel.name}}</dd></div>
              {{/if}}
              {{#if @controller.canCheckEmails}}
                <div><dt class="email">{{i18n "user.email.title"}}</dt>
                  <dd class="email" title={{@controller.model.email}}>
                    {{#if @controller.model.email}}
                      {{@controller.model.email}}
                    {{else}}
                      <DButton @action={{fn (routeAction "checkEmail") @controller.model}} @icon="envelope" @label="admin.users.check_email.text" class="btn-primary" />
                    {{/if}}
                  </dd>
                </div>
              {{/if}}
              {{#if @controller.model.displayGroups}}
                <div><dt class="groups">{{i18n "groups.title" count=@controller.model.displayGroups.length}}</dt>
                  <dd class="groups">
                    {{#each @controller.model.displayGroups as |group|}}
                      <span><LinkTo @route="group" @model={{group.name}} class="group-link">{{group.name}}</LinkTo></span>
                    {{/each}}

                    <LinkTo @route="groups" @query={{hash username=@controller.model.username}}>
                      ...
                    </LinkTo>
                  </dd>
                </div>
              {{/if}}

              {{#if @controller.canDeleteUser}}
                <div class="pull-right"><DButton @action={{action "adminDelete"}} @icon="triangle-exclamation" @label="user.admin_delete" class="btn-danger btn-delete-user" /></div>
              {{/if}}

              <PluginOutlet @name="user-profile-secondary" @outletArgs={{hash model=@controller.model}} />
            </dl>
          </div>
        {{/unless}}
      </div>
    </section>

    <div class="new-user-wrapper">
      <UserNav @user={{@controller.model}} @isStaff={{@controller.currentUser.staff}} @isMobileView={{@controller.site.mobileView}} @showActivityTab={{@controller.showActivityTab}} @showNotificationsTab={{@controller.showNotificationsTab}} @showPrivateMessages={{@controller.showPrivateMessages}} @canInviteToForum={{@controller.canInviteToForum}} @showBadges={{@controller.showBadges}} @currentParentRoute={{@controller.currentParentRoute}} @showRead={{@controller.showRead}} @showDrafts={{@controller.showDrafts}} @showBookmarks={{@controller.showBookmarks}} />

      <div class="new-user-content-wrapper">
        {{outlet}}
      </div>
    </div>
  </section>
</div></template>)