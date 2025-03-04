import { fn } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import RouteTemplate from "ember-route-template";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import DButton from "discourse/components/d-button";
import LoadMore from "discourse/components/load-more";
import TextField from "discourse/components/text-field";
import avatar from "discourse/helpers/avatar";
import bodyClass from "discourse/helpers/body-class";
import dIcon from "discourse/helpers/d-icon";
import formatDate from "discourse/helpers/format-date";
import formatDuration from "discourse/helpers/format-duration";
import htmlSafe from "discourse/helpers/html-safe";
import iN from "discourse/helpers/i18n";
import number from "discourse/helpers/number";
import rawDate from "discourse/helpers/raw-date";
export default RouteTemplate(<template>
  {{bodyClass "user-invites-page"}}

  {{#if @controller.canInviteToForum}}
    <LoadMore
      @id="user-content"
      @selector=".user-invite-list tr"
      @action={{action "loadMore"}}
      class="user-content"
    >
      <section class="user-additional-controls">
        {{#if @controller.showSearch}}
          <div class="user-invite-search">
            <form><TextField
                @value={{@controller.searchTerm}}
                @placeholderKey="user.invited.search"
              /></form>
          </div>
        {{/if}}
        <section class="user-invite-buttons">
          <DButton
            @icon="plus"
            @action={{@controller.createInvite}}
            @label="user.invited.create"
            class="btn-default invite-button"
          />
          {{#if @controller.canBulkInvite}}
            {{#if @controller.siteSettings.allow_bulk_invite}}
              {{#if @controller.site.desktopView}}
                <DButton
                  @icon="upload"
                  @action={{@controller.createInviteCsv}}
                  @label="user.invited.bulk_invite.text"
                  class="btn-default"
                />
              {{/if}}
            {{/if}}
          {{/if}}
          {{#if @controller.showBulkActionButtons}}
            {{#if @controller.inviteExpired}}
              {{#if @controller.removedAll}}
                <span class="removed-all">
                  {{iN "user.invited.removed_all"}}
                </span>
              {{else}}
                <DButton
                  @icon="xmark"
                  @action={{@controller.destroyAllExpired}}
                  @label="user.invited.remove_all"
                />
              {{/if}}
            {{/if}}

            {{#if @controller.invitePending}}
              {{#if @controller.reinvitedAll}}
                <span class="reinvited-all">
                  <DButton
                    @icon="check"
                    @disabled={{true}}
                    @label="user.invited.reinvited_all"
                  />
                </span>
              {{else if @controller.hasEmailInvites}}
                <DButton
                  @icon="arrows-rotate"
                  @action={{@controller.reinviteAll}}
                  @label="user.invited.reinvite_all"
                  class="btn-default"
                />
              {{/if}}
            {{/if}}
          {{/if}}
        </section>
      </section>
      <section>
        {{#if @controller.model.invites}}
          {{#if @controller.inviteRedeemed}}
            <table class="table user-invite-list">
              <thead>
                <tr>
                  <th>{{iN "user.invited.user"}}</th>
                  <th>{{iN "user.invited.redeemed_at"}}</th>
                  {{#if @controller.model.can_see_invite_details}}
                    <th>{{iN "user.last_seen"}}</th>
                    <th>{{iN "user.invited.topics_entered"}}</th>
                    <th>{{iN "user.invited.posts_read_count"}}</th>
                    <th>{{iN "user.invited.time_read"}}</th>
                    <th>{{iN "user.invited.days_visited"}}</th>
                    <th>{{iN "user.invited.invited_via"}}</th>
                  {{/if}}
                </tr>
              </thead>
              <tbody>
                {{#each @controller.model.invites as |invite|}}
                  <tr>
                    <td>
                      <LinkTo @route="user" @model={{invite.user}}>{{avatar
                          invite.user
                          imageSize="tiny"
                        }}</LinkTo>
                      <LinkTo
                        @route="user"
                        @model={{invite.user}}
                      >{{invite.user.username}}</LinkTo>
                    </td>
                    <td>{{formatDate invite.redeemed_at}}</td>
                    {{#if @controller.model.can_see_invite_details}}
                      <td>{{formatDate invite.user.last_seen_at}}</td>
                      <td>{{number invite.user.topics_entered}}</td>
                      <td>{{number invite.user.posts_read_count}}</td>
                      <td>{{formatDuration invite.user.time_read}}</td>
                      <td>
                        <span
                          title={{iN "user.invited.days_visited"}}
                        >{{htmlSafe invite.user.days_visited}}</span>
                        /
                        <span
                          title={{iN "user.invited.account_age_days"}}
                        >{{htmlSafe invite.user.days_since_created}}</span>
                      </td>
                      <td>{{htmlSafe invite.invite_source}}</td>
                    {{/if}}
                  </tr>
                {{/each}}
              </tbody>
            </table>
          {{else}}
            <table class="table user-invite-list">
              <thead>
                <tr>
                  <th>{{iN "user.invited.invited_via"}}</th>
                  <th>{{iN "user.invited.sent"}}</th>
                  <th>{{iN "user.invited.expires_at"}}</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {{#each @controller.model.invites as |invite|}}
                  <tr>
                    <td class="invite-type">
                      <div class="label">{{iN "user.invited.invited_via"}}</div>
                      {{#if invite.email}}
                        {{dIcon "envelope"}}
                        {{invite.email}}
                      {{else}}
                        {{dIcon "link"}}
                        {{iN
                          "user.invited.invited_via_link"
                          key=invite.shortKey
                          count=invite.redemption_count
                          max=invite.max_redemptions_allowed
                        }}
                      {{/if}}

                      {{#each invite.groups as |g|}}
                        <p class="invite-extra"><a href="/g/{{g.name}}">{{dIcon
                              "users"
                            }}
                            {{g.name}}</a></p>
                      {{/each}}

                      {{#if invite.topic}}
                        <p class="invite-extra"><a
                            href={{invite.topic.url}}
                          >{{dIcon "file"}} {{invite.topic.title}}</a></p>
                      {{/if}}
                    </td>

                    <td class="invite-updated-at">
                      <div class="label">{{iN "user.invited.sent"}}</div>
                      {{formatDate invite.updated_at}}
                    </td>

                    <td class="invite-expires-at">
                      <div class="label">{{iN "user.invited.expires_at"}}</div>
                      {{#if @controller.inviteExpired}}
                        {{rawDate invite.expires_at}}
                      {{else if invite.expired}}
                        {{iN "user.invited.expired"}}
                      {{else}}
                        {{rawDate invite.expires_at}}
                      {{/if}}
                    </td>

                    {{#if invite.can_delete_invite}}
                      <td class="invite-actions">
                        <DButton
                          @icon="pencil"
                          @action={{fn @controller.editInvite invite}}
                          @title="user.invited.edit"
                          class="btn-default"
                        />
                        <DButton
                          @icon="trash-can"
                          @action={{fn @controller.destroyInvite invite}}
                          @title={{if
                            invite.destroyed
                            "user.invited.removed"
                            "user.invited.remove"
                          }}
                          class="cancel"
                        />
                      </td>
                    {{/if}}
                  </tr>
                {{/each}}
              </tbody>
            </table>
          {{/if}}

          <ConditionalLoadingSpinner
            @condition={{@controller.invitesLoading}}
          />
        {{else}}
          <div class="user-invite-none">
            {{#if @controller.canBulkInvite}}
              {{htmlSafe (iN "user.invited.bulk_invite.none")}}
            {{else}}
              {{iN "user.invited.none"}}
            {{/if}}
          </div>
        {{/if}}
      </section>
    </LoadMore>
  {{else}}
    <div class="alert alert-error invite-error">
      {{@controller.model.error}}
    </div>
  {{/if}}
</template>);
