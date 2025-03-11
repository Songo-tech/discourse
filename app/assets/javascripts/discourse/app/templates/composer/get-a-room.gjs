import { fn } from "@ember/helper";
import RouteTemplate from "ember-route-template";
import ComposerTipCloseButton from "discourse/components/composer-tip-close-button";
import DButton from "discourse/components/d-button";
import { htmlSafe } from "@ember/template";

export default RouteTemplate(
  <template>
    <ComposerTipCloseButton
      @action={{fn @controller.closeMessage @controller.message}}
    />

    {{htmlSafe @controller.message.body}}

    <DButton
      @label="user.private_message"
      @icon="envelope"
      @action={{fn @controller.switchPM @controller.message}}
      class="btn-primary"
    />
  </template>
);
