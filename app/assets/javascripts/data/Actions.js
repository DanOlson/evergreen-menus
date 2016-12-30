import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';

export default {
  addBeer() {
    Dispatcher.dispatch({
      type: ActionTypes.ADD_BEER
    });
  },

  markForRemoval(id) {
    Dispatcher.dispatch({
      type: ActionTypes.MARK_FOR_REMOVAL,
      id
    })
  }
};
