// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },

  runtimeConfig: {
    moviesDatabaseApiKey: process.env.MOVIES_DATABASE_API_KEY,
    moviesDatabaseAccessToken: process.env.MOVIES_DATABASE_ACCESS_TOKEN,
    moviesDatabaseUrl: process.env.MOVIES_DATABASE_URL,
  },

  tailwindcss: {
    cssPath: ["~/assets/css/tailwind.css", { injectPosition: "first" }],
    configPath: "./tailwind.config",
    exposeConfig: true,
    viewer: true,
  },

  typescript: {
    typeCheck: true,
  },

  modules: ["@nuxt/eslint", "@nuxt/test-utils/module", "@nuxtjs/tailwindcss"],

  nitro: {
    ignore: [
      "**/api/**/__tests__/**",
      "**/api/**/__tests__/**",
    ]
  }
});
