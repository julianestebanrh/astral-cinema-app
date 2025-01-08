import { objectToCamel } from 'ts-case-convert';
import type {
  ITMDBGenresApiResponse,
  ITMDBNowPlayingApiResponse,
} from '@/server/types/billboard';

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event);

  const { results } = await $fetch<ITMDBNowPlayingApiResponse>(
    `${config.app.moviesDatabaseUrl}/movie/now_playing`,
    {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${config.app.moviesDatabaseAccessToken}`,
      },
    },
  );

  const { genres } = await $fetch<ITMDBGenresApiResponse>(
    `${config.app.moviesDatabaseUrl}/genre/movie/list`,
    {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${config.app.moviesDatabaseAccessToken}`,
      },
    },
  );

  const parsedMovies = results.map((movie) => ({
    ...movie,
    genres: movie.genre_ids.map(
      (genreId) =>
        genres.find((genre: any) => genre.id === genreId)?.name ?? '',
    ),
    backdrop_path: `https://image.tmdb.org/t/p/original/${movie.backdrop_path}`,
    poster_path: `https://image.tmdb.org/t/p/w500/${movie.poster_path}`,
  }));

  return {
    movies: objectToCamel(parsedMovies),
  };
});
