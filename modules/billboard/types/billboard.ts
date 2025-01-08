import type { IMovie } from '@/modules/movies/types/movies';

export interface IGetBillboardResponse {
  movies: IMovie[];
}
