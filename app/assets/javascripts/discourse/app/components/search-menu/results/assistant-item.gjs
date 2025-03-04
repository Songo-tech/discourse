import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { focusSearchInput } from "discourse/components/search-menu";
import Category from "discourse/components/search-menu/results/type/category";
import Tag from "discourse/components/search-menu/results/type/tag";
import User from "discourse/components/search-menu/results/type/user";
import concatClass from "discourse/helpers/concat-class";
import dIcon from "discourse/helpers/d-icon";
import iN from "discourse/helpers/i18n";
import { debounce } from "discourse/lib/decorators";
import getURL from "discourse/lib/get-url";
import and from "truth-helpers/helpers/and";
import or from "truth-helpers/helpers/or";

const _itemSelectCallbacks = [];
export function addItemSelectCallback(fn) {
  _itemSelectCallbacks.push(fn);
}

export function resetItemSelectCallbacks() {
  _itemSelectCallbacks.length = 0;
}

export default class AssistantItem extends Component {
  <template>
    {{! template-lint-disable no-pointer-down-event-binding }}
    {{! template-lint-disable no-invalid-interactive }}
    <li
      class={{concatClass @typeClass "search-menu-assistant-item"}}
      {{on "keydown" this.onKeydown}}
      {{on "click" this.onClick}}
      data-usage={{@usage}}
    >
      <a class="search-link" href={{this.href}}>
        <span aria-label={{iN "search.title"}}>
          {{dIcon (or @icon "magnifying-glass")}}
        </span>

        {{#if this.prefix}}
          <span class="search-item-prefix">
            {{this.prefix}}
          </span>
        {{/if}}

        {{#if @withInLabel}}
          <span class="label-suffix">{{iN "search.in"}}</span>
        {{/if}}

        {{#if @category}}
          <Category @result={{@category}} />
          {{#if (and @tag @isIntersection)}}
            <span class="search-item-tag">
              {{dIcon "tag"}}{{@tag}}
            </span>
          {{/if}}
        {{else if @tag}}
          {{#if (and @isIntersection @additionalTags.length)}}
            <span class="search-item-tag">{{this.tagsSlug}}</span>
          {{else}}
            <span class="search-item-tag">
              <Tag @result={{@tag}} />
            </span>
          {{/if}}
        {{else if @user}}
          <span class="search-item-user">
            <User @result={{@user}} />
          </span>
        {{/if}}

        <span class="search-item-slug">
          {{#if @suffix}}
            <span class="label-suffix">{{@suffix}}</span>
          {{/if}}
          {{@label}}
        </span>
        {{#if @extraHint}}
          <span class="extra-hint">
            {{iN "search.enter_hint"}}
          </span>
        {{/if}}
      </a>
    </li>
  </template>
  @service search;
  @service appEvents;

  icon = this.args.icon || "magnifying-glass";

  get href() {
    let href = "#";
    if (this.args.category) {
      href = this.args.category.url;

      if (this.args.tags && this.args.isIntersection) {
        href = getURL(`/tag/${this.args.tag}`);
      }
    } else if (
      this.args.tags &&
      this.args.isIntersection &&
      this.args.additionalTags?.length
    ) {
      href = getURL(`/tag/${this.args.tag}`);
    }

    return href;
  }

  get prefix() {
    let prefix = "";
    if (this.args.suggestionKeyword !== "+") {
      prefix =
        this.search.activeGlobalSearchTerm
          ?.split(this.args.suggestionKeyword)[0]
          .trim() || "";
      if (prefix.length) {
        prefix = `${prefix} `;
      }
    } else {
      prefix = this.search.activeGlobalSearchTerm;
    }
    return prefix;
  }

  get tagsSlug() {
    if (!this.args.tag || !this.args.additionalTags) {
      return;
    }

    return `tags:${[this.args.tag, ...this.args.additionalTags].join("+")}`;
  }

  @action
  onKeydown(e) {
    // don't capture tab key
    if (e.key === "Tab") {
      return;
    }

    if (e.key === "Enter") {
      this.itemSelected();
    }

    if (e.key === "ArrowUp" || e.key === "ArrowDown") {
      this.search.handleArrowUpOrDown(e);
    }
  }

  @action
  onClick(e) {
    this.itemSelected();
    e.preventDefault();
    return false;
  }

  @debounce(100)
  itemSelected() {
    let updatedTerm = "";
    if (
      this.args.slug &&
      (this.args.suggestionKeyword || this.args.concatSlug)
    ) {
      updatedTerm = this.prefix.concat(this.args.slug);
    } else {
      updatedTerm = this.prefix.trim();
    }

    const inTopicContext = this.search.searchContext?.type === "topic";
    const searchTopics = !inTopicContext || this.search.activeGlobalSearchTerm;

    if (
      _itemSelectCallbacks.length &&
      !_itemSelectCallbacks.some((fn) =>
        fn({
          updatedTerm,
          searchTermChanged: this.args.searchTermChanged,
          usage: this.args.usage,
        })
      )
    ) {
      // Return early if any callbacks return false
      return;
    }

    this.args.searchTermChanged(updatedTerm, {
      searchTopics,
      ...(inTopicContext &&
        !this.args.searchAllTopics && { setTopicContext: true }),
    });
    focusSearchInput();
  }
}
