import React from 'react';
import { render } from 'react-dom';
import App from './google-match-locations/App';

(function bootstrap() {
  const root = document.getElementById('google-match-locations-app-root');

  render(<App {...window._EVERGREEN} />, root);
})();
