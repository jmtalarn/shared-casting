import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

import { defineConfig } from 'vite';
import elmPlugin from 'vite-plugin-elm';
import { VitePWA } from 'vite-plugin-pwa';

const __dirname = dirname(fileURLToPath(import.meta.url));
const pwaManifest = JSON.parse(
  readFileSync(resolve(__dirname, 'webmanifest.source.json'), 'utf-8'),
);

export default defineConfig({
  plugins: [
    elmPlugin(),
    ...VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['icon/*.png'],
      manifest: pwaManifest,
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,woff2,webmanifest}'],
        navigateFallback: '/index.html',
      },
      devOptions: {
        enabled: true,
      },
    }),
  ],
  resolve: {
    alias: [ { find: '@', replacement: resolve(__dirname, 'src') } ],
  },
});
