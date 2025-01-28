<script lang="ts" setup>
interface IProps {
  currentImageIndex: number;
  allImages: string[];
}

const props = defineProps<IProps>();

const preloadAllImages = () => {
  props.allImages.forEach((image) => {
    const img = new Image();
    img.src = image;
  })
}

onMounted(() => {
  preloadAllImages();
})
</script>

<template>
  <div class="animated-background bg-black overflow-hidden">
    <TransitionGroup name="fade-and-scale">
      <img
        v-for="(image, index) in props.allImages"
        v-show="index === props.currentImageIndex"
        :key="image"
        :src="image"
        :alt="`Background ${index + 1}`"
        class="absolute top-0 left-0 w-full h-full object-cover" />
    </TransitionGroup>

    <div class="animated-background__overlay absolute top-0 left-0 w-full h-full z-10" />
  </div>
</template>

<script lang="ts">
export default {
  name: 'AnimatedBackground'
}
</script>

<style lang="css" src="./index.css" />
