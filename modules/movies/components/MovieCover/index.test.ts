import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';

import MovieCover from '@/modules/movies/components/MovieCover/index.vue';

const props = {
  title: 'Movie Title',
  imageUrl: 'https://example.com/image.jpg'
}

describe('Movies Components', () => {
  describe('MovieCover', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(MovieCover, { props });
    });

    afterEach(() => {
      vi.clearAllMocks();
    });

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      });
    });
  })
})
