import React from 'react';
import { render } from 'react-dom';
import App from './google-menu/App';

(function bootstrap() {
  const root = document.getElementById('google-menu-app-root');

  render(<App {...window._EVERGREEN} />, root);
})();
