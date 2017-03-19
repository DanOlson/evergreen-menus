import React from 'react';
import { render } from 'react-dom';
import App from './App';

function getLists() {
  return window.BEERMAPPER ? window.BEERMAPPER.beers : {}
}

function bootstrap() {
  const appRoot = document.getElementById('react-app-root');

  if (appRoot) {
    const lists = getLists();
    render(<App lists={lists} />, appRoot);
  }
};

bootstrap();
