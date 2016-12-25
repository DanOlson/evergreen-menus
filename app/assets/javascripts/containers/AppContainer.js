import createApp from '../App';
import { Container } from 'flux/utils';
import Store from '../data/Store';
import React from 'react';

function getStores() {
  return [
    Store
  ];
}

function getState() {
  return {
    beers: Store.getState()
  };
}

export default Container.createFunctional(createApp(React), getStores, getState);
