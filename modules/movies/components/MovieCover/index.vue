<script lang="ts" setup>
interface IProps {
  title: string;
  imageUrl: string;
}

defineProps<IProps>();
</script>

<template>
  <div class="relative shadow-md overflow-hidden">
    <img class="movie-cover-image w-full object-cover" :src="imageUrl" :alt="title" />

    <h5 class="text-white absolute">{{ title }}</h5>
  </div>
</template>

<script lang="ts">
export default {
  name: 'MovieCover',
};
</script>

<style lang="css" src="./index.css" />
