import Ember from 'ember';

var SearchRoute = Ember.Route.extend({
  queryParams: {
    query: {
      refreshModel: true
    }
  },

  model: function(params){
    var query = params.query;
    if (!query) { return Ember.A(); }
    return this.store.query('establishment', { beer: query });
  }
});

export default SearchRoute;
