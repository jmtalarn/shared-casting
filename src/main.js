import '@fontsource/inter'; // Defaults to weight 400

import './style.css';

import { Elm } from '@/Main.elm';

const isWebOS = /Web0S/i.test(navigator.userAgent);

if (isWebOS) {
  document.documentElement.classList.add('webos');
} else {
  import('virtual:pwa-register').then(({ registerSW }) => {
    registerSW({ immediate: true });
  });
}

if (process.env.NODE_ENV === 'development') {
  const ElmDebugTransform = await import('elm-debug-transformer');

  ElmDebugTransform.register({
    simple_mode: true,
  });
}

const root = document.querySelector('#app');
const app = Elm.Main.init({ node: root, flags: null });

app.ports.toggleDialog.subscribe(dialogSelector => {
  const dialog = document.querySelector(dialogSelector);
  if (dialog) {
    if (dialog.open) {
      dialog.close();
    } else {
      dialog.showModal();
    }
  }
});

app.ports.scroll.subscribe(function ([ elementId, amount ]) {
  const el = document.getElementById(elementId);
  if (el) {
    el.scrollBy({ left: amount, behavior: 'smooth' });
  }
});

window.addEventListener('keydown', event => {
  const isBack = event.keyCode === 461 || event.key === 'Back' || event.key === 'GoBack';
  if (!isBack || !document.querySelector('dialog[open]')) {
    return;
  }

  event.preventDefault();
  app.ports.webosBack.send(null);
});
