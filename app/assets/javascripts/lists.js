import React from 'react';
import { render } from 'react-dom';
import ListApp from './list/App';

(function bootstrap() {
  const listRoot = document.getElementById('app-root');

  function foo () {
    console.log('foo')
    console.log('sometimes you foo')
  }

  foo();

  render(<ListApp {...window._EVERGREEN} />, listRoot);
})();
