import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';

import BillboardHero from '@/modules/billboard/components/BillboardHero/index.vue';
import type { IMovie } from '~/modules/movies/types/movies';

const props = {
  movies: [
    {
      id: 1,
      title: 'Movie 1',
      posterPath: 'https://example.com/poster1.jpg',
      genres: ['Genre 1', 'Genre 2'],
      voteAverage: 8.5,
      backdropPath: 'https://example.com/backdrop1.jpg',
    }
  ] as IMovie[],
};

describe('Billboard Components', () => {
  describe('BillboardHero', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(BillboardHero, { props });
    });

    afterEach(() => {
      vi.clearAllMocks();
    });

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      });
    });

    describe('computed', () => {
      describe('currentMovie', () => {
        it('should return the current movie', () => {
          expect(wrapper.vm.currentMovie).toEqual(props.movies[0]);
        });

        it('should return null if movies is empty', async () => {
          await wrapper.setProps({ movies: [] });

          expect(wrapper.vm.currentMovie).toBeNull();
        });
      })

      describe('genresHumanizedText', () => {
        it('should return the genres of the current movie', () => {
          expect(wrapper.vm.genresHumanizedText).toEqual(expect.stringContaining(','));
        });

        it('should return an empty string if movies are empty', async () => {
          await wrapper.setProps({ movies: [] });

          expect(wrapper.vm.genresHumanizedText).toBe('');
        });
      })
    })
  });
});
