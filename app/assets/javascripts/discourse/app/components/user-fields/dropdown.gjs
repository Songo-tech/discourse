import UserFieldBase from "./base";
import { concat, fn, hash } from "@ember/helper";
import i18n from "discourse/helpers/i18n";
import ComboBox from "select-kit/components/combo-box";
import htmlSafe from "discourse/helpers/html-safe";

export default class UserFieldDropdown extends UserFieldBase {<template><label class="control-label alt-placeholder" for={{concat "user-" this.elementId}}>
  {{this.field.name}}
  {{~#unless this.field.required}} {{i18n "user_fields.optional"}}{{/unless~}}
</label>

<div class="controls">
  <ComboBox @id={{concat "user-" this.elementId}} @content={{this.field.options}} @valueProperty={{null}} @nameProperty={{null}} @value={{this.value}} @onChange={{fn (mut this.value)}} @options={{hash none=this.noneLabel}} />
  <div class="instructions">{{htmlSafe this.field.description}}</div>
</div></template>}
