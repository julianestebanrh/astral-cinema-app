import { shallowMount, type VueWrapper } from '@vue/test-utils';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import AnimatedBackground from '@/modules/common/components/AnimatedBackground/index.vue';

const props = {
  currentImageIndex: 0,
  allImages: [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg'
  ]
}

describe('Common Components', () => {
  describe('AnimatedBackground', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(AnimatedBackground, { props });
    })

    afterEach(() => {
      vi.clearAllMocks();
    })

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper).toBeDefined();
      });
    })
  })
})
