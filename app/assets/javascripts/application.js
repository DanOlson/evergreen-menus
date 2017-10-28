import React from 'react';
import { render } from 'react-dom';
import App from './list/App';
import ListsApp from './ListsApp';
import MenuApp from './menu/MenuApp';
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
  const listsRoot          = document.getElementById('lists-app');
  const menuRoot           = document.getElementById('menu-app-root');
  const digitalDisplayRoot = document.getElementById('digital-display-app-root');
  const confirmNodes       = document.querySelectorAll('[data-confirm]');

  if (appRoot) {
    render(<App {...window.BEERMAPPER} />, appRoot);
  }

  if (listsRoot) {
    render(<ListsApp {...window.BEERMAPPER} />, listsRoot);
  }

  if (menuRoot) {
    render(<MenuApp {...window.BEERMAPPER} />, menuRoot);
  }

  if (digitalDisplayRoot) {
    render(<DigitalDisplayApp {...window.BEERMAPPER} />, digitalDisplayRoot);
  }

  for (let i = 0; i < confirmNodes.length; i++) {
    applyConfirm(confirmNodes[i]);
  }
})();
