import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import * as path from "path";

export default defineConfig({
	plugins: [elmPlugin()],
	resolve: {
		alias: [{ find: "@", replacement: path.resolve(__dirname, "src") }],
	},
});
