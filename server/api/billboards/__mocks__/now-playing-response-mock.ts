import { TMDB_BASE_PAGINATED_RESPONSE_MOCK } from './tmdb-base-mocks';

export const nowPlayingResponseMock = {
  ...TMDB_BASE_PAGINATED_RESPONSE_MOCK,
  "dates": {
    "maximum": "2025-01-15",
    "minimum": "2024-12-04"
  },
  "results": new Array(5).fill({
    "adult": false,
    "backdrop_path": "/euYIwmwkmz95mnXvufEmbL6ovhZ.jpg",
    "genre_ids": [
      28,
      12,
      18
    ],
    "id": 558449,
    "original_language": "en",
    "original_title": "Gladiator II",
    "overview": "Years after witnessing the death of the revered hero Maximus at the hands of his uncle, Lucius is forced to enter the Colosseum after his home is conquered by the tyrannical Emperors who now lead Rome with an iron fist. With rage in his heart and the future of the Empire at stake, Lucius must look to his past to find strength and honor to return the glory of Rome to its people.",
    "popularity": 4201.992,
    "poster_path": "/2cxhvwyEwRlysAmRH4iodkvo0z5.jpg",
    "release_date": "2024-11-05",
    "title": "Gladiator II",
    "video": false,
    "vote_average": 6.776,
    "vote_count": 2105
  }),
}
