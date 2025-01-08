export interface ITMDBDate {
  maximum: Date;
  minimum: Date;
}

export interface ITMDBPaginatedApiResponse<ResultType> {
  results: ResultType[];
  page: number;
  total_pages: number;
  total_results: number;
}
