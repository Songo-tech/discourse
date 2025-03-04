import RouteTemplate from 'ember-route-template'
import DStyles from "discourse/components/d-styles";
import DVirtualHeight from "discourse/components/d-virtual-height";
import DiscourseRoot from "discourse/components/discourse-root";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import iN from "discourse/helpers/i18n";
import DDocument from "discourse/components/d-document";
import PageLoadingSlider from "discourse/components/page-loading-slider";
import PluginOutlet from "discourse/components/plugin-outlet";
import { hash } from "@ember/helper";
import GlimmerSiteHeader from "discourse/components/glimmer-site-header";
import routeAction from "discourse/helpers/route-action";
import SoftwareUpdatePrompt from "discourse/components/software-update-prompt";
import OfflineIndicator from "discourse/components/offline-indicator";
import and from "truth-helpers/helpers/and";
import Sidebar from "discourse/components/sidebar";
import LoadingSliderFallbackSpinner from "discourse/components/loading-slider-fallback-spinner";
import CustomHtml from "discourse/components/custom-html";
import NotificationConsentBanner from "discourse/components/notification-consent-banner";
import PwaInstallBanner from "discourse/components/pwa-install-banner";
import GlobalNotice from "discourse/components/global-notice";
import CardContainer from "discourse/components/card-container";
import PoweredByDiscourse from "discourse/components/powered-by-discourse";
import ModalContainer from "discourse/components/modal-container";
import DialogHolder from "dialog-holder/components/dialog-holder";
import TopicEntrance from "discourse/components/topic-entrance";
import ComposerContainer from "discourse/components/composer-container";
import RenderGlimmerContainer from "discourse/components/render-glimmer-container";
import FooterNav from "discourse/components/footer-nav";
import DMenus from "float-kit/components/d-menus";
import DTooltips from "float-kit/components/d-tooltips";
import DToasts from "float-kit/components/d-toasts";
export default RouteTemplate(<template><DStyles />
<DVirtualHeight />

<DiscourseRoot {{didInsert @controller.trackDiscoursePainted}}>
  {{#if @controller.showSkipToContent}}
    <a href="#main-container" id="skip-link">{{iN "skip_to_main_content"}}</a>
  {{/if}}
  <DDocument />
  <PageLoadingSlider />
  <PluginOutlet @name="above-site-header" @connectorTagName="div" @outletArgs={{hash currentPath=@controller.router._router.currentPath}} />

  {{#if @controller.showSiteHeader}}
    <GlimmerSiteHeader @canSignUp={{@controller.canSignUp}} @showCreateAccount={{routeAction "showCreateAccount"}} @showLogin={{routeAction "showLogin"}} @showKeyboard={{routeAction "showKeyboardShortcutsHelp"}} @toggleMobileView={{routeAction "toggleMobileView"}} @logout={{routeAction "logout"}} @sidebarEnabled={{@controller.sidebarEnabled}} @showSidebar={{@controller.showSidebar}} @toggleSidebar={{@controller.toggleSidebar}} />
  {{/if}}

  <SoftwareUpdatePrompt />

  {{#if @controller.siteSettings.enable_offline_indicator}}
    <OfflineIndicator />
  {{/if}}

  <PluginOutlet @name="below-site-header" @connectorTagName="div" @outletArgs={{hash currentPath=@controller.router._router.currentPath}} />

  <div id="main-outlet-wrapper" class="wrap" role="main">
    <div class="sidebar-wrapper">
      {{!-- empty div allows for animation --}}
      {{#if (and @controller.sidebarEnabled @controller.showSidebar)}}
        <Sidebar @toggleSidebar={{action "toggleSidebar"}} />
      {{/if}}
    </div>

    <LoadingSliderFallbackSpinner />

    <PluginOutlet @name="before-main-outlet" />

    <div id="main-outlet">
      <PluginOutlet @name="above-main-container" @connectorTagName="div" />
      <div class="container" id="main-container">
        {{#if @controller.showTop}}
          <CustomHtml @name="top" />
        {{/if}}
        <NotificationConsentBanner />
        <PwaInstallBanner />
        <GlobalNotice />
        <PluginOutlet @name="top-notices" @connectorTagName="div" @outletArgs={{hash currentPath=@controller.router._router.currentPath}} />
      </div>

      {{outlet}}

      <CardContainer />
      <PluginOutlet @name="main-outlet-bottom" @outletArgs={{hash showFooter=@controller.showFooter}} />
    </div>

    <PluginOutlet @name="after-main-outlet" />

    {{#if @controller.showPoweredBy}}
      <PoweredByDiscourse />
    {{/if}}
  </div>

  <PluginOutlet @name="above-footer" @connectorTagName="div" @outletArgs={{hash showFooter=@controller.showFooter}} />
  {{#if @controller.showFooter}}
    <CustomHtml @name="footer" @triggerAppEvent="true" @classNames="custom-footer-content" />
  {{/if}}
  <PluginOutlet @name="below-footer" @connectorTagName="div" @outletArgs={{hash showFooter=@controller.showFooter}} />

  <ModalContainer />
  <DialogHolder />
  <TopicEntrance />
  <ComposerContainer />
  <RenderGlimmerContainer />

  {{#if @controller.showFooterNav}}
    <PluginOutlet @name="footer-nav">
      <FooterNav />
    </PluginOutlet>
  {{/if}}
</DiscourseRoot>

<DMenus />
<DTooltips />
<DToasts /></template>)