import React from 'react';
import { render } from 'react-dom';
import ListApp from './list/App';

(function bootstrap() {
  const listRoot = document.getElementById('app-root');

  render(<ListApp {...window._EVERGREEN} />, listRoot);
})();
