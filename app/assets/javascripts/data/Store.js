import { ReduceStore } from 'flux/utils';
import ActionTypes from './ActionTypes';
import Dispatcher from './Dispatcher';
import { find as ensureArrayFind } from '../polyfills/array'
import { assign as ensureAssign } from '../polyfills/object'

ensureArrayFind();
ensureAssign();

const assign = Object.assign;

function onMarkForRemoval(state, action) {
  const beer = state.find(beer => beer.appId === action.id);
  if (beer.id) {
    const index = state.indexOf(beer);
    const newBeer = assign({}, beer, { markedForRemoval: true });

    return [
      ...state.slice(0, index),
      newBeer,
      ...state.slice(index + 1, state.length)
    ];
  } else {
    return [...state].filter(beer => beer.appId !== action.id);
  }
}

function onKeepBeer(state, action) {
  const beer     = state.find(beer => beer.appId === action.id);
  const index    = state.indexOf(beer);
  const newBeer  = assign({}, beer, { markedForRemoval: false });
  const newState = [
    ...state.slice(0, index),
    newBeer,
    ...state.slice(index + 1, state.length)
  ];

  return newState;
}

function onAddBeer(state, action) {
  const nextAppId = state.length;
  const newBeer   = { name: '', appId: nextAppId };

  return [...state, newBeer];
}

function onBeerNameChanged(state, action) {
  const beer     = state.find(beer => beer.appId === action.id);
  if (beer.name === action.text) return state;
  const index    = state.indexOf(beer);
  const newBeer  = assign({}, beer, {
    name: action.text,
    focusName: true,
    focusPrice: false
  });
  const newState = [
    ...state.slice(0, index),
    newBeer,
    ...state.slice(index + 1, state.length)
  ]
  return newState;
}

function onBeerPriceChanged(state, action) {
  const beer     = state.find(beer => beer.appId === action.id);
  const index    = state.indexOf(beer);
  const newBeer  = assign({}, beer, {
    price: action.price,
    focusPrice: true,
    focusName: false
  });
  const newState = [
    ...state.slice(0, index),
    newBeer,
    ...state.slice(index + 1, state.length)
  ]
  return newState;
}

class Store extends ReduceStore {
  constructor() {
    super(Dispatcher);
  }

  getInitialState() {
    const beers = window.BEERMAPPER ? window.BEERMAPPER.beers : []
    return [...beers].map((beer, index) => {
      beer.appId = index;
      return beer;
    });
  }

  areEqual(prevState, nextState) {
    if (super.areEqual(prevState, nextState)) {
      // Check if the same beers are markedForRemoval
      const extractAppIdsToDestroy = (state) => {
        const beersToDestroy = state.filter(b => b.markedForRemoval)
        return beersToDestroy.map(beer => beer.appId).sort();
      }
      const prevToDestroy = extractAppIdsToDestroy(prevState);
      const nextToDestroy = extractAppIdsToDestroy(nextState);

      return prevToDestroy === nextToDestroy;
    } else {
      return false
    }
  }

  reduce(state, action) {
    switch (action.type) {
      case ActionTypes.ADD_BEER:
        return onAddBeer(state, action);
      case ActionTypes.MARK_FOR_REMOVAL:
        return onMarkForRemoval(state, action);
      case ActionTypes.KEEP_BEER:
        return onKeepBeer(state, action);
      case ActionTypes.BEER_NAME_DID_CHANGE:
        return onBeerNameChanged(state, action);
      case ActionTypes.BEER_PRICE_DID_CHANGE:
        return onBeerPriceChanged(state, action);
      default:
        return state;
    }
  }
};

export default new Store();
