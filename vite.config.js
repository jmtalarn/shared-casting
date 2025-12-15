import { defineConfig, loadEnv } from 'vite';
import elmPlugin from 'vite-plugin-elm';
import * as path from 'path';

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), 'VITE_');

  return {
    plugins: [elmPlugin()],
    define: { __APP_ENV__: JSON.stringify(mode) },
    resolve: {
      alias: [{ find: '@', replacement: path.resolve(__dirname, 'src') }],
    },
  };
});
