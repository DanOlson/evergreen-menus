import Ember from 'ember';

const SearchRoute = Ember.Route.extend({
  queryParams: {
    query: {
      refreshModel: true
    }
  },

  model(params) {
    var query = params.query;
    if (!query) { return Ember.A(); }
    return this.store.query('establishment', { beer: query });
  }
});

export default SearchRoute;
