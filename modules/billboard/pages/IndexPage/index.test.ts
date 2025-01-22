import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import type { VueWrapper } from '@vue/test-utils';
import { mountSuspended, registerEndpoint } from '@nuxt/test-utils/runtime'

import IndexPage from '@/modules/billboard/pages/IndexPage/index.vue';

const getBillboardsMock = vi.fn().mockReturnValue({
  movies: [
    {
      id: 1,
      title: 'Movie 1',
      posterPath: 'https://example.com/poster1.jpg',
      genres: ['Genre 1', 'Genre 2'],
      voteAverage: 8.5,
      backdropPath: 'https://example.com/backdrop1.jpg',
    }
  ]
})

registerEndpoint('/api/billboards', getBillboardsMock)

describe('Billboard Pages', () => {
  describe('IndexPage', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(async () => {
      wrapper = await mountSuspended(IndexPage);
    })

    afterEach(() => {
      vi.clearAllMocks();
    })

    describe('mount', () => {
      it('should render BillboardHero correctly if there are data', () => {
        expect(wrapper.vm.data.value).toEqual(expect.objectContaining({
          movies: expect.arrayContaining([
            expect.objectContaining({
              title: expect.any(String),
              genres: expect.arrayContaining([expect.any(String)]),
              backdropPath: expect.any(String),
              posterPath: expect.any(String),
            })
          ])
        }))

        expect(wrapper.vm).toBeDefined();
 
        expect(wrapper.findComponent({ name: 'BillboardHero' }).exists()).toBe(true);
      });

      it('shouldn\'t render BillboardHero if there are no data', async () => {
        getBillboardsMock.mockReturnValueOnce(null)

        wrapper = await mountSuspended(IndexPage);

        expect(wrapper.findComponent({ name: 'BillboardHero' }).exists()).toBe(false);
      })
    })
  })
})
