import '@fontsource/inter'; // Defaults to weight 400

import './style.css';

import { Elm } from '@/Main.elm';

if (process.env.NODE_ENV === 'development') {
  const ElmDebugTransform = await import('elm-debug-transformer');

  ElmDebugTransform.register({
    simple_mode: true,
  });
}
console.log('API:', import.meta.env.VITE_API_BASE);

const root = document.querySelector('#app');
const app = Elm.Main.init({ node: root, flags: { apiBase: import.meta.env.VITE_API_BASE } });

app.ports.toggleDialog.subscribe(dialogSelector => {
  const dialog = document.querySelector(dialogSelector);
  if (dialog) {
    if (dialog.open) {
      dialog.close?.();
    } else {
      dialog.showModal?.();
    }
  }
});

app.ports.scroll.subscribe(function ([elementId, amount]) {
  const el = document.getElementById(elementId);
  if (el) {
    el.scrollBy({ left: amount, behavior: 'smooth' });
  }
});
