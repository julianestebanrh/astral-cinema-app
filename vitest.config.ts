import { defineVitestConfig } from '@nuxt/test-utils/config';

export default defineVitestConfig({
  test: {
    environment: 'jsdom',
    coverage: {
      provider: 'v8',
    },
    server: {
      deps: {
        inline: ['@nuxt/test-utils'],
      },
    },
  },
});
