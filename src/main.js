import "@fontsource/inter"; // Defaults to weight 400

import "./style.css";

import { Elm } from "@/Main.elm";

if (process.env.NODE_ENV === "development") {
	const ElmDebugTransform = await import("elm-debug-transformer");

	ElmDebugTransform.register({
		simple_mode: true,
	});
}

const root = document.querySelector("#app");
const app = Elm.Main.init({ node: root });

app.ports.toggleDialog.subscribe((dialogSelector) => {
	const dialog = document.querySelector(dialogSelector);
	if (dialog) {
		if (dialog.open) {
			dialog.close?.();
		} else {
			dialog.showModal?.();
		}
	}
});
