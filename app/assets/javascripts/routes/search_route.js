Beermapper.SearchRoute = Ember.Route.extend({
  model: function(params){
    var query = params.query;
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
