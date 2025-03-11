import DModal from "discourse/components/d-modal";
import FastEdit from "discourse/components/fast-edit";
import i18n from "discourse/helpers/i18n";

const FastEdit0 = <template>
  <DModal @title={{i18n "post.quote_edit"}} @closeModal={{@closeModal}}>
    <FastEdit
      @newValue={{@model.newValue}}
      @initialValue={{@model.initialValue}}
      @post={{@model.post}}
      @close={{@closeModal}}
    />
  </DModal>
</template>;
export default FastEdit0;
