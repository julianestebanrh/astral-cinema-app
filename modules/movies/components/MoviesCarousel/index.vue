<script lang="ts" setup>
import MovieCover from '@/modules/movies/components/MovieCover/index.vue';
import type { IMovie } from '@/modules/movies/types/movies';

interface IProps {
  movies: IMovie[];
}

defineProps<IProps>();

const trackRef = useTemplateRef<HTMLUListElement>('movies-carousel-track');

const emit = defineEmits(['movie-click']);

const onClick = (index: number, evt: MouseEvent) => {
  if (trackRef.value) {
    const trackWidth = trackRef.value.getBoundingClientRect().width
    const clickedEl = evt.target as HTMLElement;
    const parent = clickedEl.parentElement as HTMLLIElement;
    const parentScrollPosition = parent.offsetLeft;
    const parentWidth = parent.getBoundingClientRect().width;

    const distanceToMove = parentScrollPosition - (trackWidth / 2) + (parentWidth / 2);

    trackRef.value.scrollTo({
      left: distanceToMove,
      behavior: 'smooth',
    })
  }

  emit('movie-click', index)
}
</script>

<template>
  <ul
    ref="movies-carousel-track"
    class="movie-covers-list flex gap-8 overflow-x-scroll relative">
    <li v-for="(movie, index) in movies" :key="movie.id">
      <MovieCover
        class="w-[250px] md:w-[300px]"
        :title="movie.title"
        :image-url="movie.posterPath"
        @click="($evt) => onClick(index, $evt)" />
    </li>
  </ul>
</template>

<script lang="ts">
export default {
  name: 'MoviesCarousel',
}
</script>
