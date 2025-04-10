<script setup lang="ts">
import Navigation from "./components/Navigation.vue";
</script>

<template>
  <div class="h-full grid lg:grid-cols-[15rem_1fr] max-lg:grid-rows-[1fr_5rem] bg-surface-50 dark:bg-surface-800">
    <!-- Static sidebar for desktop -->
    <div class="h-full w-full max-lg:order-2">
      <Navigation :active-index=4></Navigation>
    </div>
    <RouterView class="m-4 max-lg:order-1"></RouterView>
  </div>
</template>

