import Component from "@ember/component";
import { isEmpty } from "@ember/utils";
import { classNameBindings, tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";

@tagName("section")
@classNameBindings(
  ":category-boxes",
  "anyLogos:with-logos:no-logos",
  "hasSubcategories:with-subcategories"
)
export default class CategoriesBoxes extends Component {
  lockIcon = "lock";

  @discourseComputed("categories.[].uploaded_logo.url")
  anyLogos() {
    return this.categories.any((c) => !isEmpty(c.get("uploaded_logo.url")));
  }

  @discourseComputed("categories.[].subcategories")
  hasSubcategories() {
    return this.categories.any((c) => !isEmpty(c.get("subcategories")));
  }
}
<PluginOutlet
  @name="categories-boxes-wrapper"
  @outletArgs={{hash categories=this.categories}}
>
  {{#each this.categories as |c|}}
    <PluginOutlet
      @name="category-box-before-each-box"
      @outletArgs={{hash category=c}}
    />

    <div
      style={{category-color-variable c.color}}
      data-category-id={{c.id}}
      data-notification-level={{c.notificationLevelString}}
      data-url={{c.url}}
      class="category category-box category-box-{{c.slug}}
        {{if c.isMuted 'muted'}}"
    >
      <div class="category-box-inner">
        {{#unless c.isMuted}}
          <div class="category-logo">
            {{#if c.uploaded_logo.url}}
              <CategoryLogo @category={{c}} />
            {{/if}}
          </div>
        {{/unless}}

        <div class="category-details">
          <div class="category-box-heading">
            <a class="parent-box-link" href={{c.url}}>
              <h3>
                <CategoryTitleBefore @category={{c}} />
                {{#if c.read_restricted}}
                  {{d-icon this.lockIcon}}
                {{/if}}
                {{c.displayName}}
              </h3>
            </a>
          </div>

          {{#unless c.isMuted}}
            <div class="description">
              {{html-safe c.description_excerpt}}
            </div>

            {{#if c.isGrandParent}}
              {{#each c.subcategories as |subcategory|}}
                <div
                  data-category-id={{subcategory.id}}
                  data-notification-level={{subcategory.notificationLevelString}}
                  style={{border-color subcategory.color}}
                  class="subcategory with-subcategories
                    {{if subcategory.uploaded_logo.url 'has-logo' 'no-logo'}}"
                >
                  <div class="subcategory-box-inner">
                    <CategoryTitleLink
                      @tagName="h4"
                      @category={{subcategory}}
                    />
                    {{#if subcategory.subcategories}}
                      <div class="subcategories">
                        {{#each subcategory.subcategories as |subsubcategory|}}
                          {{#unless subsubcategory.isMuted}}
                            <span class="subcategory">
                              <CategoryTitleBefore
                                @category={{subsubcategory}}
                              />
                              {{category-link subsubcategory hideParent="true"}}
                            </span>
                          {{/unless}}
                        {{/each}}
                      </div>
                    {{/if}}
                  </div>
                </div>
              {{/each}}
            {{else if c.subcategories}}
              <div class="subcategories">
                {{#each c.subcategories as |sc|}}
                  <a class="subcategory" href={{sc.url}}>
                    <span class="subcategory-image-placeholder">
                      {{#if sc.uploaded_logo.url}}
                        <CategoryLogo @category={{sc}} />
                      {{/if}}
                    </span>

                    {{category-link sc hideParent="true"}}
                  </a>
                {{/each}}
              </div>
            {{/if}}
          {{/unless}}
        </div>

        <PluginOutlet
          @name="category-box-below-each-category"
          @outletArgs={{hash category=c}}
        />
      </div>
    </div>

    <PluginOutlet
      @name="category-box-after-each-box"
      @outletArgs={{hash category=c}}
    />
  {{/each}}
</PluginOutlet>

<PluginOutlet
  @name="category-boxes-after-boxes"
  @outletArgs={{hash category=this.c}}
/>