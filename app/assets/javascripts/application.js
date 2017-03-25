import React from 'react';
import { render } from 'react-dom';
import App from './App';

function getList() {
  return window.BEERMAPPER ? window.BEERMAPPER.list : {}
}

(function bootstrap() {
  const appRoot = document.getElementById('app-root');

  if (appRoot) {
    render(<App list={getList()} />, appRoot);
  }
})();
