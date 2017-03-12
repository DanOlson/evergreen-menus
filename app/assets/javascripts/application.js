import React from 'react';
import { render } from 'react-dom';
import App from './App';

function bootstrap() {
  const appRoot = document.getElementById('react-app-root');

  if (appRoot) {
    render(<App />, appRoot);
  }
};

bootstrap();
