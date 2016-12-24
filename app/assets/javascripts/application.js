import React from 'react';
import { render } from 'react-dom';
import createApp from './App';

function bootstrap() {
  const appRoot = document.getElementById('react-app-root');

  if (appRoot) {
    const App = createApp(React);
    const beers = getBeers(); // <-- TODO: replace
    render(
      <App beers={beers} />,
      appRoot
    );
  }
};

bootstrap();
