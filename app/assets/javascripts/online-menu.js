import React from 'react';
import { render } from 'react-dom';
import App from './online-menu/App';

(function bootstrap() {
  const root = document.getElementById('online-menu-app-root');

  render(<App {...window._EVERGREEN} />, root);
})();
