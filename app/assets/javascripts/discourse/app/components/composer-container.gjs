import Component from "@glimmer/component";
import { service } from "@ember/service";
import ComposerBody from "discourse/components/composer-body";
import htmlClass from "discourse/helpers/html-class";
import ComposerMessages from "discourse/components/composer-messages";
import ComposerFullscreenPrompt from "discourse/components/composer-fullscreen-prompt";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash, fn } from "@ember/helper";
import ComposerActionTitle from "discourse/components/composer-action-title";
import i18n from "discourse/helpers/i18n";
import icon from "discourse/helpers/d-icon";
import LinkToInput from "discourse/components/link-to-input";
import TextField from "discourse/components/text-field";
import ComposerToggles from "discourse/components/composer-toggles";
import ComposerEditor from "discourse/components/composer-editor";
import ComposerUserSelector from "discourse/components/composer-user-selector";
import concatClass from "discourse/helpers/concat-class";
import { Input } from "@ember/component";
import ComposerTitle from "discourse/components/composer-title";
import CategoryChooser from "select-kit/components/category-chooser";
import PopupInputTip from "discourse/components/popup-input-tip";
import MiniTagChooser from "select-kit/components/mini-tag-chooser";
import ComposerSaveButton from "discourse/components/composer-save-button";
import DButton from "discourse/components/d-button";
import { on } from "@ember/modifier";
import or from "truth-helpers/helpers/or";
import loadingSpinner from "discourse/helpers/loading-spinner";
import avatar from "discourse/helpers/avatar";
import and from "truth-helpers/helpers/and";
import htmlSafe from "discourse/helpers/html-safe";

export default class ComposerContainer extends Component {
  @service composer;
  @service site;
<template><ComposerBody @composer={{this.composer.model}} @showPreview={{this.composer.isPreviewVisible}} @openIfDraft={{this.composer.openIfDraft}} @typed={{this.composer.typed}} @cancelled={{this.composer.cancelled}} @save={{this.composer.saveAction}}>
  <div class="grippie"></div>
  {{#if this.composer.visible}}
    {{htmlClass (if this.composer.isPreviewVisible "composer-has-preview")}}
    <ComposerMessages @composer={{this.composer.model}} @messageCount={{this.composer.messageCount}} @addLinkLookup={{this.composer.addLinkLookup}} />

    {{#if this.composer.showFullScreenPrompt}}
      <ComposerFullscreenPrompt @removeFullScreenExitPrompt={{this.composer.removeFullScreenExitPrompt}} />
    {{/if}}

    {{#if this.composer.model.viewOpenOrFullscreen}}
      <div role="dialog" aria-label={{this.composer.ariaLabel}} class="reply-area
          {{if this.composer.canEditTags "with-tags" "without-tags"}}
          {{if this.composer.hasFormTemplate "with-form-template" "without-form-template"}}
          {{if this.composer.model.showCategoryChooser "with-category" "without-category"}}">
        <span class="composer-open-plugin-outlet-container">
          <PluginOutlet @name="composer-open" @connectorTagName="div" @outletArgs={{hash model=this.composer.model}} />
        </span>

        <div class="reply-to">
          {{#unless this.composer.model.viewFullscreen}}
            <div class="reply-details">
              <ComposerActionTitle @model={{this.composer.model}} @canWhisper={{this.composer.canWhisper}} />

              <PluginOutlet @name="composer-action-after" @outletArgs={{hash model=this.composer.model}} />

              {{#if this.site.desktopView}}
                {{#if this.composer.model.unlistTopic}}
                  <span class="unlist">({{i18n "composer.unlist"}})</span>
                {{/if}}
                {{#if this.composer.isWhispering}}
                  {{#if this.composer.model.noBump}}
                    <span class="no-bump">{{icon "anchor"}}</span>
                  {{/if}}
                {{/if}}
              {{/if}}

              {{#if this.composer.canEdit}}
                <LinkToInput @onClick={{this.composer.displayEditReason}} @showInput={{this.composer.showEditReason}} @icon="circle-info" class="display-edit-reason">
                  <TextField @value={{this.composer.editReason}} @id="edit-reason" @maxlength="255" @placeholderKey="composer.edit_reason_placeholder" />
                </LinkToInput>
              {{/if}}
            </div>
          {{/unless}}

          <PluginOutlet @name="before-composer-controls" @outletArgs={{hash model=this.composer.model}} />

          <ComposerToggles @composeState={{this.composer.model.composeState}} @showToolbar={{this.composer.showToolbar}} @toggleComposer={{this.composer.toggle}} @toggleToolbar={{this.composer.toggleToolbar}} @toggleFullscreen={{this.composer.fullscreenComposer}} @disableTextarea={{this.composer.disableTextarea}} />
        </div>

        <ComposerEditor>
          <div class="composer-fields">
            <PluginOutlet @name="before-composer-fields" @outletArgs={{hash model=this.composer.model}} />
            {{#unless this.composer.model.viewFullscreen}}
              {{#if this.composer.model.canEditTitle}}
                {{#if this.composer.model.creatingPrivateMessage}}
                  <div class="user-selector">
                    <ComposerUserSelector @topicId={{this.composer.topicModel.id}} @recipients={{this.composer.model.targetRecipients}} @hasGroups={{this.composer.model.hasTargetGroups}} @focusTarget={{this.composer.focusTarget}} class={{concatClass "users-input" (if this.composer.showWarning "can-warn")}} />
                    {{#if this.composer.showWarning}}
                      <label class="add-warning">
                        <Input @type="checkbox" @checked={{this.composer.model.isWarning}} />
                        <span>{{i18n "composer.add_warning"}}</span>
                      </label>
                    {{/if}}
                  </div>
                {{/if}}

                <div class="title-and-category
                    {{if this.composer.isPreviewVisible "with-preview"}}">
                  <ComposerTitle @composer={{this.composer.model}} @lastValidatedAt={{this.composer.lastValidatedAt}} @focusTarget={{this.composer.focusTarget}} />

                  {{#if this.composer.model.showCategoryChooser}}
                    <div class="category-input">
                      <CategoryChooser @value={{this.composer.model.categoryId}} @onChange={{this.composer.updateCategory}} @options={{hash disabled=this.composer.disableCategoryChooser scopedCategoryId=this.composer.scopedCategoryId prioritizedCategoryId=this.composer.prioritizedCategoryId}} />
                      <PluginOutlet @name="after-composer-category-input" @outletArgs={{hash composer=this.composer.model}} />
                      <PopupInputTip @validation={{this.composer.categoryValidation}} />
                    </div>
                  {{/if}}

                  {{#if this.composer.canEditTags}}
                    <div class="tags-input">
                      <MiniTagChooser @value={{this.composer.model.tags}} @onChange={{fn (mut this.composer.model.tags)}} @options={{hash disabled=this.composer.disableTagsChooser categoryId=this.composer.model.categoryId minimum=this.composer.model.minimumRequiredTags}} />
                      <PluginOutlet @name="after-composer-tag-input" @outletArgs={{hash composer=this.composer.model}} />
                      <PopupInputTip @validation={{this.composer.tagValidation}} />
                    </div>
                  {{/if}}

                  <PluginOutlet @name="after-title-and-category" @outletArgs={{hash model=this.composer.model tagValidation=this.composer.tagValidation canEditTags=this.composer.canEditTags disabled=this.composer.disableTagsChooser}} />
                </div>
              {{/if}}

              <span>
                <PluginOutlet @name="composer-fields" @connectorTagName="div" @outletArgs={{hash model=this.composer.model showPreview=this.composer.isPreviewVisible}} />
              </span>
            {{/unless}}
          </div>
        </ComposerEditor>

        <span>
          <PluginOutlet @name="composer-after-composer-editor" @outletArgs={{hash model=this.composer.model}} />
        </span>

        <div class="submit-panel">
          <span>
            <PluginOutlet @name="composer-fields-below" @connectorTagName="div" @outletArgs={{hash model=this.composer.model}} />
          </span>

          <div class="save-or-cancel">
            <ComposerSaveButton @action={{this.composer.saveAction}} @icon={{this.composer.saveIcon}} @label={{this.composer.saveLabel}} @forwardEvent={{true}} @disableSubmit={{this.composer.disableSubmit}} />

            {{#if this.site.mobileView}}
              <DButton @action={{this.composer.cancel}} class="cancel btn-transparent" @icon={{if this.composer.canEdit "xmark" "trash-can"}} @preventFocus={{true}} @title="close" />
            {{else}}
              <DButton @action={{this.composer.cancel}} class="cancel btn-transparent" @preventFocus={{true}} @title="close" @label="close" />
            {{/if}}

            {{#if this.site.mobileView}}
              {{#if this.composer.whisperOrUnlistTopic}}
                <span class="whisper">
                  {{icon "far-eye-slash"}}
                </span>
              {{/if}}

              {{#if this.composer.model.noBump}}
                <span class="no-bump">{{icon "anchor"}}</span>
              {{/if}}
            {{/if}}

            <span>
              <PluginOutlet @name="composer-after-save-or-cancel" @outletArgs={{hash model=this.composer.model}} />
            </span>
          </div>

          {{#if this.site.mobileView}}
            <span>
              <PluginOutlet @name="composer-mobile-buttons-bottom" @outletArgs={{hash model=this.composer.model}} />
            </span>

            {{#if this.composer.allowUpload}}
              <a id="mobile-file-upload" class="btn btn-default no-text mobile-file-upload
                  {{if this.composer.isUploading "hidden"}}" aria-label={{i18n "composer.upload_title"}}>
                {{icon this.composer.uploadIcon}}
              </a>
            {{/if}}

            {{#if this.composer.allowPreview}}
              <a href class="btn btn-default no-text mobile-preview" title={{i18n "composer.show_preview"}} {{on "click" this.composer.togglePreview}} aria-label={{i18n "composer.show_preview"}}>
                {{icon "desktop"}}
              </a>
            {{/if}}

            {{#if this.composer.isPreviewVisible}}
              <DButton @action={{this.composer.togglePreview}} @title="composer.hide_preview" @ariaLabel="composer.hide_preview" @icon="pencil" class="hide-preview" />
            {{/if}}
          {{/if}}

          {{#if (or this.composer.isUploading this.composer.isProcessingUpload)}}
            <div id="file-uploading">
              {{#if this.composer.isProcessingUpload}}
                {{loadingSpinner size="small"}}<span>{{i18n "upload_selector.processing"}}</span>
              {{else}}
                {{loadingSpinner size="small"}}<span>{{i18n "upload_selector.uploading"}}
                  {{this.composer.uploadProgress}}%</span>
              {{/if}}

              {{#if this.composer.isCancellable}}
                <a href id="cancel-file-upload" {{on "click" this.composer.cancelUpload}}>{{icon "xmark"}}</a>
              {{/if}}
            </div>
          {{/if}}

          <div class={{if this.composer.isUploading "hidden"}} id="draft-status">
            {{#if this.composer.model.draftStatus}}
              <span class="draft-error" title={{this.composer.model.draftStatus}}>
                {{#if this.composer.model.draftConflictUser}}
                  {{avatar this.composer.model.draftConflictUser imageSize="small"}}
                  {{icon "user-pen"}}
                {{else}}
                  {{icon "triangle-exclamation"}}
                {{/if}}
                {{#if this.site.desktopView}}
                  {{this.composer.model.draftStatus}}
                {{/if}}
              </span>
            {{/if}}
          </div>

          {{#if (and this.composer.allowPreview this.site.desktopView)}}
            <DButton @action={{this.composer.togglePreview}} @translatedTitle={{this.composer.toggleText}} @icon="angles-left" class={{concatClass "btn-transparent btn-mini-toggle toggle-preview" (unless this.composer.isPreviewVisible "active")}} />
          {{/if}}
        </div>
      </div>
    {{else}}
      <div class="saving-text">
        {{#if this.composer.model.createdPost}}
          {{i18n "composer.saved"}}
          <a href={{this.composer.createdPost.url}} {{on "click" this.composer.viewNewReply}} class="permalink">{{i18n "composer.view_new_post"}}</a>
        {{else}}
          {{i18n "composer.saving"}}
          {{loadingSpinner size="small"}}
        {{/if}}
      </div>

      <div class="draft-text">
        {{#if this.composer.model.topic}}
          {{icon "share"}}
          {{htmlSafe this.composer.draftTitle}}
        {{else}}
          {{i18n "composer.saved_draft"}}
        {{/if}}
      </div>

      <ComposerToggles @composeState={{this.composer.model.composeState}} @toggleFullscreen={{this.composer.openIfDraft}} @toggleComposer={{this.composer.toggle}} @toggleToolbar={{this.composer.toggleToolbar}} />
    {{/if}}
  {{/if}}
</ComposerBody></template>}
