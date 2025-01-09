<script lang="ts" setup>
import { computed } from 'vue';

interface IProps {
  value: number;
  leadingZeros?: number;
}

const props = withDefaults(defineProps<IProps>(), {
  leadingZeros: 2
});

const numberWithLeadingZeros = computed(() => {
  return props.value.toString().padStart(props.leadingZeros, '0');
});
</script>

<template>
  <div class="overflow-hidden relative flex">
    <Transition name="scroll">
      <span :key="numberWithLeadingZeros" class="inline-block text-8xl font-light">{{
        numberWithLeadingZeros
      }}</span>
    </Transition>
  </div>
</template>

<script lang="ts">
export default {
  name: 'AnimatedNumber',
}
</script>

<style lang="css">
.scroll-enter-from {
  transform: translateY(100%);
}

.scroll-enter-to,
.scroll-leave-from {
  transform: translateY(0);
}

.scroll-leave-active {
  position: absolute;
}

.scroll-leave-to {
  transform: translateY(-100%);
}

.scroll-enter-active,
.scroll-leave-active {
  transition: transform 1s ease;
}
</style>