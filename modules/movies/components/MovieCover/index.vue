<script lang="ts" setup>
interface IProps {
  title: string;
  imageUrl: string;
}

defineProps<IProps>();
</script>

<template>
  <div class="movie-cover relative">
    <div class="movie-cover__image-container shadow-md overflow-hidden">
      <img
        class="movie-cover__image w-full object-cover select-none pointer-events-none"
        :src="imageUrl"
        :alt="title" />
    </div>

    <h5 class="movie-cover__title text-white w-full text-center pointer-events-none mt-4">{{ title }}</h5>
  </div>
</template>

<script lang="ts">
export default {
  name: 'MovieCover',
};
</script>

<style lang="css" src="./index.css" />
