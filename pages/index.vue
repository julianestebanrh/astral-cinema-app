<script lang="ts" setup>
import IndexPage from '@/modules/billboard/pages/IndexPage/index.vue';

useHead({
  title: 'Watch on Astral Now!',
  meta: [
    {
      name: 'description',
      content: 'Watch on Astral Cinema Now! Book your tickets now!',
    }
  ]
})
</script>
<template>
  <div>
    <IndexPage />
  </div>
</template>
<script lang="ts">
export default {
  name: 'IndexPage',
};
</script>
