import Component from "@glimmer/component";
import { action } from "@ember/object";
import i18n from "discourse/helpers/i18n";
import CategoryChooser from "select-kit/components/category-chooser";
import { fn } from "@ember/helper";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import DButton from "discourse/components/d-button";

export default class ChangeCategory extends Component {
  categoryId = 0;

  @action
  async changeCategory() {
    await this.args.forEachPerformed(
      {
        type: "change_category",
        category_id: this.categoryId,
      },
      (t) => t.set("category_id", this.categoryId)
    );
  }
<template><p>{{i18n "topics.bulk.choose_new_category"}}</p>

<p>
  <CategoryChooser @value={{this.categoryId}} @onChange={{fn (mut this.categoryId)}} />
</p>

<ConditionalLoadingSpinner @condition={{@loading}}>
  <DButton @action={{this.changeCategory}} @label="topics.bulk.change_category" />
</ConditionalLoadingSpinner></template>}
