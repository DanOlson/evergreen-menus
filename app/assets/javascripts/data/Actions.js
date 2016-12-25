import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';

export default {
  addBeer(name) {
    Dispatcher.dispatch({
      type: ActionTypes.ADD_BEER,
      name
    });
  }
};
