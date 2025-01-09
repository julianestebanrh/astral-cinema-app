import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';
import AnimatedNumber from '@/modules/common/components/AnimatedNumber/index.vue';

const props = {
  value: 5,
  leadingZeros: 2
}

describe('Common Components', () => {
  describe('AnimatedNumber', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(AnimatedNumber, { props })
    })

    afterEach(() => {
      vi.clearAllMocks();
    })

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      });
    })

    describe('computed', () => {
      describe('numberWithLeadingZeros', () => {
        it('should return value with leading zeros', () => {
          expect(wrapper.vm.numberWithLeadingZeros).toEqual('05');
        });
      })
    })
  })
})
