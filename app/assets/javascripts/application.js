import 'core-js/es6/map';
import 'core-js/es6/set';

import React from 'react';
import { render } from 'react-dom';
import ListApp from './list/App';
import MenuApp from './menu/MenuApp';
import WebMenuApp from './web-menu/WebMenuApp';
import DigitalDisplayApp from './digital-display/DigitalDisplayApp';

function applyConfirm(element) {
  var message = element.getAttribute('data-confirm');
  if (message) {
    element.form.addEventListener('submit', function submitHandler(event) {
      if (!confirm(message)) {
        event.preventDefault();
      }
    });
  }
}

(function bootstrap() {
  const appRoot            = document.getElementById('app-root');
  const menuRoot           = document.getElementById('menu-app-root');
  const webMenuRoot        = document.getElementById('web-menu-app-root');
  const digitalDisplayRoot = document.getElementById('digital-display-app-root');
  const confirmNodes       = document.querySelectorAll('[data-confirm]');

  if (appRoot) {
    render(<ListApp {...window.BEERMAPPER} />, appRoot);
  }

  if (menuRoot) {
    render(<MenuApp {...window.BEERMAPPER} />, menuRoot);
  }

  if (digitalDisplayRoot) {
    render(<DigitalDisplayApp {...window.BEERMAPPER} />, digitalDisplayRoot);
  }

  if (webMenuRoot) {
    render(<WebMenuApp {...window.BEERMAPPER} />, webMenuRoot);
  }

  for (let i = 0; i < confirmNodes.length; i++) {
    applyConfirm(confirmNodes[i]);
  }
})();
