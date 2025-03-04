import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DModal from "discourse/components/d-modal";
import iN from "discourse/helpers/i18n";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import ScoreValue from "discourse/components/score-value";
import float from "discourse/helpers/float";
import DButton from "discourse/components/d-button";

export default class ExplainReviewable extends Component {<template><DModal class="explain-reviewable" @closeModal={{@closeModal}} @title={{iN "review.explain.title"}}>
  <:body>
    <ConditionalLoadingSpinner @condition={{this.loading}}>
      <table>
        <tbody>
          <tr>
            <th>{{iN "review.explain.formula"}}</th>
            <th>{{iN "review.explain.subtotal"}}</th>
          </tr>
          {{#each this.reviewableExplanation.scores as |s|}}
            <tr>
              <td>
                <ScoreValue @value="1.0" />
                <ScoreValue @value={{s.type_bonus}} @label="type_bonus" />
                <ScoreValue @value={{s.take_action_bonus}} @label="take_action_bonus" />
                <ScoreValue @value={{s.trust_level_bonus}} @label="trust_level_bonus" />
                <ScoreValue @value={{s.user_accuracy_bonus}} @label="user_accuracy_bonus" />
              </td>
              <td class="sum">{{float s.score}}</td>
            </tr>
          {{/each}}
          <tr class="total">
            <td>{{iN "review.explain.total"}}</td>
            <td class="sum">
              {{float this.reviewableExplanation.total_score}}
            </td>
          </tr>
        </tbody>
      </table>

      <table class="thresholds">
        <tbody>
          <tr>
            <td>{{iN "review.explain.min_score_visibility"}}</td>
            <td class="sum">
              {{float this.reviewableExplanation.min_score_visibility}}
            </td>
          </tr>
          <tr>
            <td>{{iN "review.explain.score_to_hide"}}</td>
            <td class="sum">
              {{float this.reviewableExplanation.hide_post_score}}
            </td>
          </tr>
        </tbody>
      </table>
    </ConditionalLoadingSpinner>
  </:body>
  <:footer>
    <DButton @action={{@closeModal}} @label="close" />
  </:footer>
</DModal></template>
  @service store;

  @tracked loading = true;
  @tracked reviewableExplanation = null;

  constructor() {
    super(...arguments);
    this.loadExplanation();
  }

  @action
  async loadExplanation() {
    try {
      const result = await this.store.find(
        "reviewable-explanation",
        this.args.model.reviewable.id
      );
      this.reviewableExplanation = result;
    } finally {
      this.loading = false;
    }
  }
}
