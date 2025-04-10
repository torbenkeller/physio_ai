<script setup lang="ts">

import {computed} from "vue";

const {
  size = 24,
  fill = false,
  weight = '300'
} = defineProps<{
  size?: number
  fill?: boolean
  weight?: '100' | '200' | '300' | '400' | '500' | '600' | '700'
}>()

const remSize = computed(() => {
  return size / 16.0
})

</script>

<template>
  <i class="material-symbols-rounded"
     :style="`font-size: ${remSize}rem; font-variation-settings: 'FILL' ${fill ? '1' : '0'}, 'wght' ${weight}, 'GRAD' 0, 'OPSZ' ${size};`">
    <slot></slot>
  </i>
</template>
