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
    });
  },

  keepBeer(id) {
    Dispatcher.dispatch({
      type: ActionTypes.KEEP_BEER,
      id
    });
  },

  beerNameDidChange(id, text) {
    Dispatcher.dispatch({
      type: ActionTypes.BEER_NAME_DID_CHANGE,
      id,
      text
    });
  },

  beerPriceDidChange(id, price) {
    Dispatcher.dispatch({
      type: ActionTypes.BEER_PRICE_DID_CHANGE,
      id,
      price
    });
  },
};
