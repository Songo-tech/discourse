import Component from "@ember/component";
import { isEmpty } from "@ember/utils";
import { classNameBindings, tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";
import categoryColorVariable from "discourse/helpers/category-color-variable";
import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";
import dIcon from "discourse/helpers/d-icon";
import CategoriesBoxesTopic from "discourse/components/categories-boxes-topic";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";

@tagName("section")
@classNameBindings(
  ":category-boxes-with-topics",
  "anyLogos:with-logos:no-logos"
)
export default class CategoriesBoxesWithTopics extends Component {<template>{{#each this.categories as |c|}}
  <div data-notification-level={{c.notificationLevelString}} style={{categoryColorVariable c.color}} class="category category-box category-box-{{c.slug}}
      {{if c.isMuted "muted"}}">
    <div class="category-box-inner">
      <div class="category-box-heading">
        <a class="parent-box-link" href={{c.url}}>
          {{#unless c.isMuted}}
            {{#if c.uploaded_logo.url}}
              <CategoryLogo @category={{c}} />
            {{/if}}
          {{/unless}}

          <h3>
            <CategoryTitleBefore @category={{c}} />
            {{#if c.read_restricted}}
              {{dIcon this.lockIcon}}
            {{/if}}
            {{c.displayName}}
          </h3>
        </a>
      </div>

      {{#unless c.isMuted}}
        <div class="featured-topics">
          {{#if c.topics}}
            <ul>
              {{#each c.topics as |topic|}}
                <CategoriesBoxesTopic @topic={{topic}} />
              {{/each}}
            </ul>
          {{/if}}
        </div>
      {{/unless}}

      <PluginOutlet @name="category-box-below-each-category" @outletArgs={{hash category=c}} />
    </div>
  </div>
{{/each}}</template>
  lockIcon = "lock";

  @discourseComputed("categories.[].uploaded_logo.url")
  anyLogos() {
    return this.categories.any((c) => {
      return !isEmpty(c.get("uploaded_logo.url"));
    });
  }
}
