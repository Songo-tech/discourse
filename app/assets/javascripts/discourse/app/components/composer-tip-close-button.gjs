import DButton from "discourse/components/d-button";
<template>
  <DButton
    @action={{@action}}
    @icon="xmark"
    @label="composer.esc"
    @ariaLabel="composer.esc_label"
    class="btn-transparent close"
  />
</template>
