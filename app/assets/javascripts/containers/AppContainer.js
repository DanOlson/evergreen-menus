import createApp from '../App';
import { Container } from 'flux/utils';
import Store from '../data/Store';
import Actions from '../data/Actions';
import React from 'react';

function getStores() {
  return [
    Store
  ];
}

function getState() {
  return {
    beers: Store.getState(),
    onAddBeer: Actions.addBeer
  };
}

export default Container.createFunctional(createApp(React), getStores, getState);
