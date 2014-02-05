Beermapper.SearchRoute = Ember.Route.extend({
  setupController: function(controller){
    controller.set('latitude', 44.983334);
    controller.set('longitude', -93.266670);
  },

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
