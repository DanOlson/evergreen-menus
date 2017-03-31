import React from 'react';
import { render } from 'react-dom';
import App from './App';
import ListsApp from './ListsApp';

function getList() {
  return window.BEERMAPPER ? window.BEERMAPPER.list : {};
}

function getLists() {
  return window.BEERMAPPER ? window.BEERMAPPER.lists : [];
}

(function bootstrap() {
  const appRoot = document.getElementById('app-root');
  const listsRoot = document.getElementById('lists-app');

  if (appRoot) {
    render(<App list={getList()} />, appRoot);
  }

  if (listsRoot) {
    render(<ListsApp lists={getLists()} />, listsRoot);
  }
})();
