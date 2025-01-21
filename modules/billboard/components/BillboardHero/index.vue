<script lang="ts" setup>
import { ref, computed } from 'vue';
import type { IMovie } from '@/modules/movies/types/movies';
import AnimatedNumber from '@/modules/common/components/AnimatedNumber/index.vue';
import StarsBadge from '@/modules/common/components/StarsBadge/index.vue';
import MovieCover from '@/modules/movies/components/MovieCover/index.vue';

interface Props {
  movies: IMovie[];
}

const props = defineProps<Props>();

const currentIndex = ref(0);
const currentMovie = computed(() => {
  if (!props.movies.length) return null;

  return props.movies[currentIndex.value];
});

const genresHumanizedText = computed(() => {
  if (!currentMovie.value) return '';

  return currentMovie.value.genres.join(', ');
});
</script>
<template>
  <div
class="billboard-hero flex flex-col justify-end bg-black bg-cover bg-center bg-scale-100" :style="{
    backgroundImage: `linear-gradient(
      rgba(0, 0, 0, 0) 40%,
      rgba(0, 0, 0, 0.7) 70%
    ), url(${currentMovie?.backdropPath})`
  }">
    <div class="grid grid-cols-12 items">
      <div v-if="currentMovie" class="col-span-4 flex text-white px-20">
        <div class="flex flex-col items-center relative">
          <div class="flex absolute bottom-full left-0">
            <span class="border-l-2 w-1 h-[100px] mt-4 mr-2"></span>
            <span class="font-semibold">Today</span>
          </div>

          <div class="flex flex-col items-center mr-4">
            <AnimatedNumber :value="currentIndex + 1" class="text-6xl font-bold mb-4" />

            <StarsBadge :value="currentMovie.voteAverage / 2" />
          </div>
        </div>
        <div>
          <h1 class="text-6xl font-bold mb-4">{{ currentMovie.title }}</h1>
          <p class="font-light text-sm pl-2">
            <span class="font-bold">Genre: </span>
            {{ genresHumanizedText }}
          </p>
        </div>
      </div>

      <div class="col-span-8 pb-20">
        <ul class="movie-covers-list flex gap-8 overflow-x-scroll">
          <li v-for="(movie, index) in movies" :key="movie.id">
            <MovieCover
class="w-[300px]" :title="movie.title" :image-url="movie.posterPath"
              @click="currentIndex = index" />
          </li>
        </ul>
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
