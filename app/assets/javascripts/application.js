import React from 'react';
import { render } from 'react-dom';
import App from './App';

function getBeers() {
  const beers = window.BEERMAPPER ? window.BEERMAPPER.beers : []
  const sorted = beers.sort((a, b) => {
    const aName = a.name.toLowerCase();
    const bName = b.name.toLowerCase();
    if (aName > bName) return 1;
    if (aName < bName) return -1;
    return 0;
  })
  return sorted.map((beer, index) => {
    beer.appId = index;
    return beer;
  })
}

function bootstrap() {
  const appRoot = document.getElementById('react-app-root');

  if (appRoot) {
    const beers = getBeers();
    render(<App beers={beers} />, appRoot);
  }
};

bootstrap();
