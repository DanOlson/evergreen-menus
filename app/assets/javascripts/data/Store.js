import { ReduceStore } from 'flux/utils';
import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';

class Store extends ReduceStore {
  constructor() {
    super(Dispatcher);
  }

  getInitialState() {
    return getBeers();
  }

  reduce(state, action) {
    switch (action.type) {
      case ActionTypes.ADD_BEER:
        return state;
      default:
        return state;
    }
  }
};

export default new Store();
