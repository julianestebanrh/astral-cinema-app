import { defineVitestConfig } from '@nuxt/test-utils/config';

export default defineVitestConfig({
  test: {
    environment: 'nuxt',
    setupFiles: ['./vitest.setup.ts'],
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
