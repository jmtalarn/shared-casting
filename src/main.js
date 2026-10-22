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
      const focusable = dialog.querySelector('input, button, [tabindex="0"]');
      if (focusable) {
        focusable.focus();
      }
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

if (isWebOS) {
  window.addEventListener('keydown', event => {
    const direction = arrowDirection(event);
    if (direction) {
      if (isTextEntry(document.activeElement) && (direction.x !== 0)) {
        return;
      }
      event.preventDefault();
      moveFocus(direction.x, direction.y);
      return;
    }

    const isEnter = event.keyCode === 13 || event.key === 'Enter';
    if (!isEnter) {
      return;
    }
    const current = document.activeElement;
    if (!current || current === document.body || current.tagName === 'BUTTON' || current.tagName === 'A' || current.tagName === 'INPUT') {
      return;
    }
    event.preventDefault();
    current.click();
  });

  setTimeout(() => {
    const first = document.querySelector('button');
    if (first) {
      first.focus();
    }
  }, 0);

  window.addEventListener('wheel', event => {
    const delta = event.deltaY || (event.wheelDelta ? -event.wheelDelta : 0);
    if (!delta) {
      return;
    }
    const nested = nestedScroller(event.target, delta);
    if (nested) {
      return;
    }
    event.preventDefault();
    document.body.scrollTop += delta;
  }, { passive: false });
}

function arrowDirection(event) {
  if (event.keyCode === 37 || event.key === 'ArrowLeft') {
    return { x: -1, y: 0 };
  }
  if (event.keyCode === 38 || event.key === 'ArrowUp') {
    return { x: 0, y: -1 };
  }
  if (event.keyCode === 39 || event.key === 'ArrowRight') {
    return { x: 1, y: 0 };
  }
  if (event.keyCode === 40 || event.key === 'ArrowDown') {
    return { x: 0, y: 1 };
  }
  return null;
}

function isTextEntry(element) {
  return !!element && (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA');
}

function focusRoot() {
  const openDialog = document.querySelector('dialog[open]');
  return openDialog || document.body;
}

function isFocusable(element) {
  if (!element || element.disabled || element.getAttribute('tabindex') === '-1') {
    return false;
  }
  const style = window.getComputedStyle(element);
  if (style.display === 'none' || style.visibility === 'hidden') {
    return false;
  }
  const rect = element.getBoundingClientRect();
  return rect.width > 1 && rect.height > 1;
}

function focusableElements() {
  return Array.from(focusRoot().querySelectorAll('button, a[href], input, select, textarea, [tabindex="0"]')).filter(isFocusable);
}

function centerOf(rect) {
  return {
    x: rect.left + rect.width / 2,
    y: rect.top + rect.height / 2,
  };
}

function moveFocus(dx, dy) {
  const items = focusableElements();
  if (items.length === 0) {
    return;
  }

  const current = document.activeElement;
  if (!items.includes(current)) {
    focusElement(items[0]);
    return;
  }

  const from = centerOf(current.getBoundingClientRect());
  let best = null;
  let bestScore = Infinity;

  items.forEach(item => {
    if (item === current) {
      return;
    }
    const to = centerOf(item.getBoundingClientRect());
    const deltaX = to.x - from.x;
    const deltaY = to.y - from.y;
    if (dx !== 0 && Math.sign(deltaX) !== dx) {
      return;
    }
    if (dy !== 0 && Math.sign(deltaY) !== dy) {
      return;
    }
    const primary = dx !== 0 ? Math.abs(deltaX) : Math.abs(deltaY);
    const secondary = dx !== 0 ? Math.abs(deltaY) : Math.abs(deltaX);
    if (primary < 4) {
      return;
    }
    const score = primary + secondary * 2;
    if (score < bestScore) {
      bestScore = score;
      best = item;
    }
  });

  if (best) {
    focusElement(best);
    return;
  }

  const scroller = scrollParent(current);
  scroller.scrollBy({ left: dx * 180, top: dy * 180 });
}

function focusElement(element) {
  element.focus();
  reveal(element);
}

function reveal(element) {
  const scroller = scrollParent(element);
  const elementRect = element.getBoundingClientRect();
  const scrollerRect = scroller === document.body || scroller === document.documentElement
    ? { top: 0, bottom: window.innerHeight, left: 0, right: window.innerWidth }
    : scroller.getBoundingClientRect();
  const margin = 48;

  if (elementRect.top < scrollerRect.top + margin) {
    scroller.scrollTop += elementRect.top - (scrollerRect.top + margin);
  } else if (elementRect.bottom > scrollerRect.bottom - margin) {
    scroller.scrollTop += elementRect.bottom - (scrollerRect.bottom - margin);
  }

  if (elementRect.left < scrollerRect.left + margin) {
    scroller.scrollLeft += elementRect.left - (scrollerRect.left + margin);
  } else if (elementRect.right > scrollerRect.right - margin) {
    scroller.scrollLeft += elementRect.right - (scrollerRect.right - margin);
  }
}

function nestedScroller(target, deltaY) {
  let parent = target instanceof Element ? target : null;
  while (parent && parent !== document.body) {
    const style = window.getComputedStyle(parent);
    if (/(auto|scroll)/.test(style.overflowY) && parent.scrollHeight > parent.clientHeight + 1) {
      const atTop = parent.scrollTop <= 0 && deltaY < 0;
      const atBottom = parent.scrollTop + parent.clientHeight >= parent.scrollHeight - 1 && deltaY > 0;
      if (!atTop && !atBottom) {
        return parent;
      }
    }
    parent = parent.parentElement;
  }
  return null;
}

function scrollParent(element) {
  let parent = element.parentElement;
  while (parent) {
    const style = window.getComputedStyle(parent);
    if (/(auto|scroll)/.test(style.overflowY) || /(auto|scroll)/.test(style.overflowX)) {
      return parent;
    }
    parent = parent.parentElement;
  }
  return document.scrollingElement || document.body;
}
