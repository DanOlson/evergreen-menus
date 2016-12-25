import React from 'react';
import { render } from 'react-dom';
import AppContainer from './containers/AppContainer';

function bootstrap() {
  const appRoot = document.getElementById('react-app-root');

  if (appRoot) {
    render(<AppContainer />, appRoot);
  }
};

bootstrap();
