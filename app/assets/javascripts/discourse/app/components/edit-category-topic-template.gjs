import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { schedule } from "@ember/runloop";
import { observes } from "@ember-decorators/object";
import { buildCategoryPanel } from "discourse/components/edit-category-panel";
import discourseComputed from "discourse/lib/decorators";
import DToggleSwitch from "discourse/components/d-toggle-switch";
import { on } from "@ember/modifier";
import FormTemplateChooser from "select-kit/components/form-template-chooser";
import { fn } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import i18n from "discourse/helpers/i18n";
import DEditor from "discourse/components/d-editor";

export default class EditCategoryTopicTemplate extends buildCategoryPanel(
  "topic-template"
) {
  @tracked _showFormTemplateOverride;

  get showFormTemplate() {
    return (
      this._showFormTemplateOverride ??
      Boolean(this.category.get("form_template_ids.length"))
    );
  }

  set showFormTemplate(value) {
    this._showFormTemplateOverride = value;
  }

  @discourseComputed("showFormTemplate")
  templateTypeToggleLabel(showFormTemplate) {
    if (showFormTemplate) {
      return "admin.form_templates.edit_category.toggle_form_template";
    }

    return "admin.form_templates.edit_category.toggle_freeform";
  }

  @action
  toggleTemplateType() {
    this.toggleProperty("showFormTemplate");

    if (!this.showFormTemplate) {
      // Clear associated form templates if switching to freeform
      this.set("category.form_template_ids", []);
    }
  }

  @observes("activeTab", "showFormTemplate")
  _activeTabChanged() {
    if (this.activeTab && !this.showFormTemplate) {
      schedule("afterRender", () =>
        this.element.querySelector(".d-editor-input").focus()
      );
    }
  }
<template>{{#if this.siteSettings.experimental_form_templates}}
  <div class="control-group">
    <DToggleSwitch class="toggle-template-type" @state={{this.showFormTemplate}} @label={{this.templateTypeToggleLabel}} {{on "click" this.toggleTemplateType}} />
  </div>

  {{#if this.showFormTemplate}}
    <div class="control-group">
      <FormTemplateChooser @value={{this.category.form_template_ids}} @onChange={{fn (mut this.category.form_template_ids)}} class="select-category-template" />

      <p class="select-category-template__info desc">
        {{#if this.currentUser.staff}}
          <LinkTo @route="adminCustomizeFormTemplates">
            {{i18n "admin.form_templates.edit_category.select_template_help"}}
          </LinkTo>
        {{/if}}
      </p>
    </div>
  {{else}}
    <DEditor @value={{this.category.topic_template}} @showLink={{this.showInsertLinkButton}} />
  {{/if}}
{{else}}
  <DEditor @value={{this.category.topic_template}} @showLink={{this.showInsertLinkButton}} />
{{/if}}</template>}
