import React from 'react';
import { render } from 'react-dom';
import App from './App';
import ListsApp from './ListsApp';
import MenuApp from './menu/MenuApp';

function getList() {
  return window.BEERMAPPER ? window.BEERMAPPER.list : {};
}

function getLists() {
  return window.BEERMAPPER ? window.BEERMAPPER.lists : [];
}

function getMenu() {
  return window.BEERMAPPER ? window.BEERMAPPER.menu : {};
}

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
  const appRoot      = document.getElementById('app-root');
  const listsRoot    = document.getElementById('lists-app');
  const menuRoot     = document.getElementById('menu-app-root');
  const confirmNodes = document.querySelectorAll('[data-confirm]');

  if (appRoot) {
    render(<App list={getList()} />, appRoot);
  }

  if (listsRoot) {
    render(<ListsApp lists={getLists()} />, listsRoot);
  }

  if (menuRoot) {
    const {
      cancelEditMenuPath,
      downloadMenuPath,
      menuFormSubmitText,
      canDestroyMenu,
      fontOptions
    } = window.BEERMAPPER;
    render(
      <MenuApp
        menu={getMenu()}
        lists={getLists()}
        cancelEditMenuPath={cancelEditMenuPath}
        downloadMenuPath={downloadMenuPath}
        menuFormSubmitText={menuFormSubmitText}
        canDestroyMenu={canDestroyMenu}
        fontOptions={fontOptions}
      />,
      menuRoot
    );
  }

  for (let i = 0; i < confirmNodes.length; i++) {
    applyConfirm(confirmNodes[i]);
  }
})();
