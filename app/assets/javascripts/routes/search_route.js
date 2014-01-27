Beermapper.SearchRoute = Ember.Route.extend({
  model: function(params){
    var query = params.queryParams.query;
    var controller = this.controllerFor('search');
    controller.set('query', query);
    if (!query) {
      return [];
    }
    return this.store.find('establishment', { beer: query });
  },

  actions: {
    queryParamsDidChange: function(){
      this.refresh();
    }
  }
});
