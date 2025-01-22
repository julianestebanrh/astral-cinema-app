<script lang="ts" setup>
import BillboardHero from '@/modules/billboard/components/BillboardHero/index.vue';
import type { IGetBillboardResponse } from '@/modules/billboard/types/billboard';

const { data } = await useAsyncData<IGetBillboardResponse>('billboard', () => {
  // @ts-ignore
  return $fetch('/api/billboards');
});
</script>
<template>
  <div>
    <BillboardHero v-if="data" class="min-h-screen" :movies="data.movies" />
  </div>
</template>
<script lang="ts">
export default {
  name: 'IndexPage',
};
</script>
