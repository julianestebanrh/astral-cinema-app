import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';

import BillboardHero from '@/modules/billboard/components/BillboardHero/index.vue';

describe('Billboard Components', () => {
  describe('BillboardHero', () => {
    let wrapper: VueWrapper;

    beforeEach(() => {
      wrapper = shallowMount(BillboardHero);
    });

    afterEach(() => {
      vi.clearAllMocks();
    });

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      });
    });
  });
});
