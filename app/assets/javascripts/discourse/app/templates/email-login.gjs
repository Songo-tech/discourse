import RouteTemplate from 'ember-route-template'
import htmlSafe from "discourse/helpers/html-safe";
import SecurityKeyForm from "discourse/components/security-key-form";
import { fn } from "@ember/helper";
import SecondFactorForm from "discourse/components/second-factor-form";
import SecondFactorInput from "discourse/components/second-factor-input";
import { on } from "@ember/modifier";
import withEventValue from "discourse/helpers/with-event-value";
import iN from "discourse/helpers/i18n";
import DButton from "discourse/components/d-button";
export default RouteTemplate(<template><div class="container email-login clearfix">
  <div class="content-wrapper">
    <div class="image-wrapper">
      <img src={{@controller.lockImageUrl}} class="password-reset-img" alt />
    </div>

    <form>
      {{#if @controller.model.error}}
        <div class="error-info">
          {{htmlSafe @controller.model.error}}
        </div>
      {{/if}}

      {{#if @controller.model.can_login}}
        <div class="email-login-form">
          {{#if @controller.secondFactorRequired}}
            {{#if @controller.model.security_key_required}}
              <SecurityKeyForm @setShowSecurityKey={{fn (mut @controller.model.security_key_required)}} @setSecondFactorMethod={{fn (mut @controller.secondFactorMethod)}} @backupEnabled={{@controller.model.backup_codes_enabled}} @totpEnabled={{@controller.model.totp_enabled}} @otherMethodAllowed={{@controller.secondFactorRequired}} @action={{@controller.authenticateSecurityKey}} />
            {{else}}
              <SecondFactorForm @secondFactorMethod={{@controller.secondFactorMethod}} @secondFactorToken={{@controller.secondFactorToken}} @backupEnabled={{@controller.model.backup_codes_enabled}} @totpEnabled={{@controller.model.totp_enabled}} @isLogin={{true}}>
                <SecondFactorInput {{on "input" (withEventValue (fn (mut @controller.secondFactorToken)))}} @secondFactorMethod={{@controller.secondFactorMethod}} value={{@controller.secondFactorToken}} />
              </SecondFactorForm>
            {{/if}}
          {{else}}
            <h2>{{iN "email_login.confirm_title" site_name=@controller.siteSettings.title}}</h2>
            <p>{{iN "email_login.logging_in_as" email=@controller.model.token_email}}</p>
          {{/if}}

          {{#unless @controller.model.security_key_required}}
            <DButton @label="email_login.confirm_button" @action={{action "finishLogin"}} type="submit" class="btn-primary" />
          {{/unless}}
        </div>
      {{/if}}
    </form>
  </div>
</div></template>)