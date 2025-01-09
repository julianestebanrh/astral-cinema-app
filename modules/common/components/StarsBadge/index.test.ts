import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { shallowMount, type VueWrapper } from '@vue/test-utils';
import StarsBadge from '@/modules/common/components/StarsBadge/index.vue';

const props = {
  value: 3,
  maxValue: 5
}

describe('Common Components', () => {
  describe('StarsBadge', () => {
    let wrapper: VueWrapper<any>;

    beforeEach(() => {
      wrapper = shallowMount(StarsBadge, { props });
    })

    afterEach(() => {
      vi.clearAllMocks();
    })

    describe('mount', () => {
      it('should render correctly', () => {
        expect(wrapper.vm).toBeDefined();
      });

      it('should include solid and outlined star icons', () => {
        expect(wrapper.findAll('.stars-badge__star--outlined')).toHaveLength(2)
        expect(wrapper.findAll('.stars-badge__star--solid')).toHaveLength(3)
      })
    })
  })
})