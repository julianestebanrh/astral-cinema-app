import { configDefaults } from 'vitest/config';
import { defineVitestConfig } from '@nuxt/test-utils/config';

const filesToExclude = [
  ...configDefaults.exclude,
  '**/node_modules/**',
  '**/.nuxt/**',
  '**/types/**',
  './nuxt.config.ts',
  './tailwind.config.ts',
]

export default defineVitestConfig({
  test: {
    environment: 'nuxt',
    setupFiles: ['./vitest.setup.ts'],
    exclude: filesToExclude,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      all: true,
      exclude: filesToExclude,
    },
    server: {
      deps: {
        inline: ['@nuxt/test-utils'],
      },
    },
  },
});
