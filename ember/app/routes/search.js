import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    query: {
      refreshModel: true
    }
  },

  model(params) {
    const query = params.query;
    if (!query) { return Ember.A(); }
    return this.store.query('establishment', { beer: query });
  }
});
