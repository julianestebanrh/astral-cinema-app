<script lang="ts" setup>
import { StarIcon as OutlinedStarIcon } from '@heroicons/vue/24/outline';
import { StarIcon as SolidStarIcon } from '@heroicons/vue/24/solid';

interface IProps {
  value: number;
  maxValue?: number;
}

withDefaults(defineProps<IProps>(), {
  maxValue: 5
})
</script>

<template>
  <div class="flex">
    <span v-for="star in maxValue" :key="star" class=" text-yellow-400">
      <component
:is="star > value ? OutlinedStarIcon : SolidStarIcon" class="size-4"
        :class="star > value ? 'stars-badge__star--outlined' : 'stars-badge__star--solid'" />
    </span>
  </div>
</template>

<script lang="ts">
export default {
  name: 'StarsBadge',
}
</script>
