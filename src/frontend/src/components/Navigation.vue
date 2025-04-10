<script setup lang="ts">

import Icon from "./Icon.vue";
import {useRoute} from "vue-router";
import {computed} from "vue";

const navigation = [
  {name: 'Home', href: '/', icon: 'home'},
  {name: 'Patienten', href: '/patienten', icon: 'group'},
  {name: 'Rezepte', href: '/rezepte', icon: 'sticky_note_2'},
  {name: 'Termine', href: '/termine', icon: 'event'},
  {name: 'Rechnungen', href: '/rechnungen', icon: 'print'},
];

const route = useRoute();

const activeIndex = computed(() =>
    navigation.findIndex((item) =>
        route.fullPath === item.href
    ));
</script>

<template>
  <div class="flex lg:h-full flex-col lg:gap-y-5 lg:overflow-y-auto lg:ml-4">
    <div class="lg:flex lg:h-16 lg:shrink-0 lg:items-center max-lg:hidden">
      <img class="h-8 w-auto" src="https://tailwindui.com/plus/img/logos/mark.svg?color=indigo&shade=600"
           alt="Your Company"/>
    </div>
    <nav class="flex lg:flex-col lg:gap-2 max-lg:flex-row max-lg:justify-evenly max-lg:px-4">
      <RouterLink v-for="(item, index) in navigation" :to="item.href"
                  class="group flex lg:gap-x-3 rounded-md lg:p-2 lg:text-sm/6 max-lg:text-xs/4 font-semibold max-lg:flex-col max-lg:items-center max-lg:gap-1 max-lg:shrink max-lg:pt-3 max-lg:pb-4"
                  :class="index == activeIndex ? 'lg:bg-primary lg:text-primary-contrast max-lg:text-color' : 'text-color lg:hover:bg-highlight'">
        <Icon
            class="lg:size-6 lg:shrink-0 max-lg:rounded-md max-lg:px-5 max-lg:py-1"
            :class="[activeIndex == index ? 'max-lg:bg-primary text-primary-contrast' : 'max-lg:group-hover:bg-highlight']"
            aria-hidden="true">
          {{ item.icon }}
        </Icon>
        {{ item.name }}
      </RouterLink>
    </nav>
  </div>
</template>

<style scoped>

</style>