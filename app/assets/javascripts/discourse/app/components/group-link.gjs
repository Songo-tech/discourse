import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class GroupLink extends Component {
  @service currentUser;
  @service siteSettings;

  get name() {
    return this.args.name || this.args.group?.name;
  }

  get href() {
    return this.args.href || this.args.group?.url;
  }

  <template>
    <a
      ...attributes
      class="user-group trigger-group-card"
      href={{this.href}}
      data-group-card={{this.name}}
    >
      {{yield}}
    </a>
  </template>
}
