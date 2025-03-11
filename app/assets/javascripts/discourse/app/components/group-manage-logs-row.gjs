import Component from "@ember/component";
import { fn, hash } from "@ember/helper";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import DButton from "discourse/components/d-button";
import avatar from "discourse/helpers/avatar";
import boundDate from "discourse/helpers/bound-date";
import i18n from "discourse/helpers/i18n";

@tagName("")
export default class GroupManageLogsRow extends Component {
  expandDetails = false;

  @action
  toggleDetails() {
    this.toggleProperty("expandDetails");
  }

  @action
  filter(params) {
    this.set(`filters.${params.key}`, params.value);
  }

  <template>
    <tr class="group-manage-logs-row">
      <td>
        <DButton
          @action={{fn this.filter (hash value=this.log.action key="action")}}
          @translatedLabel={{this.log.actionTitle}}
          class="btn-default"
        />
      </td>

      <td>
        <span>{{avatar this.log.acting_user imageSize="tiny"}}</span>
        <DButton
          @action={{fn
            this.filter
            (hash value=this.log.acting_user.username key="acting_user")
          }}
          @translatedLabel={{this.log.acting_user.username}}
          class="btn-default"
        />
      </td>

      <td>
        {{#if this.log.target_user}}
          <span>{{avatar this.log.target_user imageSize="tiny"}}</span>
          <DButton
            @action={{fn
              this.filter
              (hash value=this.log.target_user.username key="target_user")
            }}
            @translatedLabel={{this.log.target_user.username}}
            class="btn-default"
          />
        {{/if}}
      </td>

      <td>
        {{#if this.log.subject}}
          <DButton
            @action={{fn
              this.filter
              (hash value=this.log.subject key="subject")
            }}
            @translatedLabel={{this.log.subject}}
            class="btn-default"
          />
        {{/if}}
      </td>

      <td>{{boundDate this.log.created_at}}</td>

      <td class="group-manage-logs-expand-details">
        {{#if this.log.prev_value}}
          <DButton
            @action={{this.toggleDetails}}
            @icon={{if this.expandDetails "angle-up" "angle-down"}}
          />
        {{/if}}
      </td>
    </tr>

    {{#if this.expandDetails}}
      <tr>
        <td colspan="6">
          <p>
            <strong>{{i18n "groups.manage.logs.from"}}</strong>:
            <code>{{this.log.prev_value}}</code>
          </p>

          <p>
            <strong>{{i18n "groups.manage.logs.to"}}</strong>:
            <code>{{this.log.new_value}}</code>
          </p>
        </td>
      </tr>
    {{/if}}
  </template>
}
