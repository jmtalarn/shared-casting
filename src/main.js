import '@fontsource/inter'; // Defaults to weight 400

import './style.css';

import { Elm } from '@/Main.elm';

if (process.env.NODE_ENV === 'development') {
  const ElmDebugTransform = await import('elm-debug-transformer');

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const apiBase = import.meta.env.DEV ? __API_BASE_DEV__ : __API_BASE_PROD__;

console.log('API base:', apiBase);
console.log('Mode:', import.meta.env.MODE);

const root = document.querySelector('#app');
const app = Elm.Main.init({ node: root, flags: { apiBase: apiBase } });

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
