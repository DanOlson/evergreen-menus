import { ReduceStore } from 'flux/utils';
import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';
import { find as ensureArrayFind } from '../polyfills/array'

ensureArrayFind();

function onMarkForRemoval(state, action) {
  const beer = state.find(beer => beer.appId === action.id);
  const newState = [...state];
  if (beer.id) {
    beer.markedForRemoval = true;
    return newState;
  } else {
    return newState.filter(beer => beer.appId !== action.id);
  }
}

function onAddBeer(state, action) {
  const appIds    = state.map(beer => beer.appId);
  const nextAppId = appIds.length;
  const newBeer   = { name: '', appId: nextAppId };

  return [...state, newBeer];
}

class Store extends ReduceStore {
  constructor() {
    super(Dispatcher);
  }

  getInitialState() {
    return [...window.BEERMAPPER.beers].map((beer, index) => {
      beer.appId = index;
      return beer;
    });
  }

  reduce(state, action) {
    switch (action.type) {
      case ActionTypes.ADD_BEER:
        return onAddBeer(state, action);
      case ActionTypes.MARK_FOR_REMOVAL:
        return onMarkForRemoval(state, action);
      default:
        return state;
    }
  }
};

export default new Store();
