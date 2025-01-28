<script lang="ts" setup>
import { ref, computed } from 'vue';
import type { IMovie } from '@/modules/movies/types/movies';
import AnimatedBackground from '@/modules/common/components/AnimatedBackground/index.vue';
import AnimatedNumber from '@/modules/common/components/AnimatedNumber/index.vue';
import StarsBadge from '@/modules/common/components/StarsBadge/index.vue';
import MoviesCarousel from '@/modules/movies/components/MoviesCarousel/index.vue';

interface IProps {
  movies: IMovie[];
}

const props = defineProps<IProps>();

const currentIndex = ref(0);
const currentMovie = computed(() => {
  if (!props.movies.length) return null;

  return props.movies[currentIndex.value];
});

const genresHumanizedText = computed(() => {
  if (!currentMovie.value) return '';

  return currentMovie.value.genres.join(', ');
});

const allBackgrounds = computed(() => {
  return props.movies.map((movie) => movie.backdropPath);
})
</script>
<template>
  <div class="billboard-hero flex flex-col justify-end bg-black bg-cover bg-center bg-scale-100">
    <AnimatedBackground
      :current-image-index="currentIndex"
      :all-images="allBackgrounds"
      class="absolute top-0 left-0 z-0 w-full h-full" />

    <div class="grid grid-cols-12 items">
      <div v-if="currentMovie" class="col-span-12 lg:col-span-5 flex text-white px-8 lg:px-20 mb-12 lg:mb-0">
        <div class="flex flex-col items-center relative">
          <div class="flex absolute bottom-full left-0">
            <span class="border-l-2 w-1 h-[100px] mt-4 mr-2"></span>
            <span class="font-semibold">Today</span>
          </div>

          <div class="flex flex-col items-center mr-4">
            <AnimatedNumber :value="currentIndex + 1" class="text-6xl lg:text-8xl font-bold mb-4" />

            <StarsBadge :value="currentMovie.voteAverage / 2" />
          </div>
        </div>
        <div class="z-10">
          <h1 class="text-3xl lg:text-6xl font-bold mb-4">{{ currentMovie.title }}</h1>
          <p class="font-light text-sm pl-2">
            <span class="font-bold">Genre: </span>
            {{ genresHumanizedText }}
          </p>
        </div>
      </div>

      <div class="col-span-12 lg:col-span-7 pb-10">
        <MoviesCarousel
          :movies
          @movie-click="currentIndex = $event" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  name: 'BillboardHero',
};
</script>

<style lang="css" src="./index.css" />
