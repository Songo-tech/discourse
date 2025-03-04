import { fn } from "@ember/helper";
import RouteTemplate from "ember-route-template";
import ComposerTipCloseButton from "discourse/components/composer-tip-close-button";
import htmlSafe from "discourse/helpers/html-safe";
export default RouteTemplate(<template>
  <ComposerTipCloseButton
    @action={{fn @controller.closeMessage @controller.message}}
  />

  <p>
    {{htmlSafe @controller.message.body}}
  </p>
</template>);
