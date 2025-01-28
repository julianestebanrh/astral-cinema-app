import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';

import MoviesCarousel from '@/modules/movies/components/MoviesCarousel/index.vue';

const props = {
  movies: [
    {
      id: 1,
      title: 'Movie 1',
      overview: 'Overview 1',
      posterPath: 'https://example.com/poster1.jpg',
      releaseDate: '2022-01-01',
      voteAverage: 7.5,
      backdropPath: 'https://example.com/backdrop1.jpg',
      genres: ['Action', 'Adventure']
    },
    {
      id: 2,
      title: 'Movie 2',
      overview: 'Overview 2',
      posterPath: 'https://example.com/poster2.jpg',
      releaseDate: '2022-02-02',
      voteAverage: 6.5,
      backdropPath: 'https://example.com/backdrop2.jpg',
      genres: ['Comedy', 'Drama']
    },
    {
      id: 3,
      title: 'Movie 3',
      overview: 'Overview 3',
      posterPath: 'https://example.com/poster3.jpg',
      releaseDate: '2022-03-03',
      voteAverage: 8.5,
      backdropPath: 'https://example.com/backdrop3.jpg',
      genres: ['Action', 'Adventure']
    }
  ]
}

describe('Common Components', () => {
  describe('MoviesCarousel', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(MoviesCarousel, { props });
    })

    afterEach(() => {
      vi.clearAllMocks();
    })

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      })
    })

    describe('UI events', () => {
      it('should emit click event', async () => {
        const movieToClick = wrapper.findComponent({ name: 'MovieCover' });

        await movieToClick.trigger('click');

        expect(wrapper.emitted('movie-click')).toHaveLength(1);
      })
    })
  })
})
