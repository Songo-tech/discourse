import icon from "discourse/helpers/d-icon";
import getUrl from "discourse/helpers/get-url";
import { htmlSafe } from "@ember/template";
import i18n from "discourse/helpers/i18n";

const MessagesListEmptyState = <template>
  <div class="empty-state">
    <span class="empty-state-title">
      {{i18n "user.no_messages_title"}}
    </span>
    <div class="empty-state-body">
      <p>
        {{htmlSafe
          (i18n
            "user.no_messages_body"
            icon=(icon "envelope")
            aboutUrl=(getUrl "/about")
          )
        }}
      </p>
    </div>
  </div>
</template>;
export default MessagesListEmptyState;
