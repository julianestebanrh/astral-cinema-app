import type { ITMDBDate, ITMDBPaginatedApiResponse } from '@/server/types/tmdb';
import type { ITMDBGenre, ITMDBMovie } from '@/server/types/billboard/entities';

export interface ITMDBNowPlayingApiResponse extends ITMDBPaginatedApiResponse<ITMDBMovie> {
  dates: ITMDBDate;
}

export interface ITMDBGenresApiResponse {
  genres: ITMDBGenre[];
}
