import { ReduceStore } from 'flux/utils';
import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';
import { find as ensureArrayFind } from '../polyfills/array'

ensureArrayFind();

class Store extends ReduceStore {
  constructor() {
    super(Dispatcher);
  }

  getInitialState() {
    return window.BEERMAPPER.beers;
  }

  reduce(state, action) {
    switch (action.type) {
      case ActionTypes.ADD_BEER:
        const newBeer = { name: '' };

        return [...state, newBeer];
      case ActionTypes.MARK_FOR_REMOVAL:
        const beer = state.find(beer => beer.id === action.id);
        beer.markedForRemoval = true;
        return [...state];
      default:
        return state;
    }
  }
};

export default new Store();
