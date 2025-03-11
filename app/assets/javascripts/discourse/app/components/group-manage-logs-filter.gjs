import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

@tagName("")
export default class GroupManageLogsFilter extends Component {
  @discourseComputed("type")
  label(type) {
    return i18n(`groups.manage.logs.${type}`);
  }

  @discourseComputed("value", "type")
  filterText(value, type) {
    return type === "action" ? i18n(`group_histories.actions.${value}`) : value;
  }
}
{{#if this.value}}
  <DButton
    @action={{fn this.clearFilter this.type}}
    @icon="circle-xmark"
    @translatedLabel={{concat this.label ": " this.filterText}}
    class="btn-default group-manage-logs-filter"
  />
{{/if}}