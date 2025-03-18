import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import i18n from "discourse/helpers/i18n";
import TagChooser from "select-kit/components/tag-chooser";
import DButton from "discourse/components/d-button";
import { fn, hash } from "@ember/helper";
import not from "truth-helpers/helpers/not";

export default class ChangeTags extends Component {
  @tracked tags = [];
<template><p>{{i18n "topics.bulk.choose_new_tags"}}</p>

<p><TagChooser @tags={{this.tags}} @categoryId={{@categoryId}} /></p>

<DButton @action={{fn @performAndRefresh (hash type="change_tags" tags=this.tags)}} @disabled={{not this.tags}} @label="topics.bulk.change_tags" /></template>}
