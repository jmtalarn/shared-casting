import { defineConfig, loadEnv } from 'vite';
import elmPlugin from 'vite-plugin-elm';
import * as path from 'path';

export default defineConfig(({ mode }) => {
  const env = loadEnv('tauri', process.cwd(), 'VITE_');

  console.log('Vite mode:', mode);
  console.log('VITE_API_BASE_DEV:', env.VITE_API_BASE_DEV);

  return {
    plugins: [elmPlugin()],
    define: {
      __APP_ENV__: JSON.stringify(mode),
      __API_BASE_DEV__: JSON.stringify(env.VITE_API_BASE_DEV),
      __API_BASE_PROD__: JSON.stringify(env.VITE_API_BASE_PROD),
    },
    resolve: {
      alias: [{ find: '@', replacement: path.resolve(__dirname, 'src') }],
    },
  };
});
