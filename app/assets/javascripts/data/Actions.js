import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';

export default {
  addBeer() {
    Dispatcher.dispatch({
      type: ActionTypes.ADD_BEER
    });
  }
};
