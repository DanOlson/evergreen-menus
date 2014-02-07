Beermapper.SearchRoute = Ember.Route.extend({
  model: function(params){
    var query = params.query;
    if (!query) {
      return [];
    }
    return this.store.find('establishment', { beer: query });
  },

  afterModel: function(){
    var controller = this.controllerFor('search');
    var map = controller.get('map');
    if (map.hasOwnProperty('mapTypeId')) {
      controller.placeMarkers();
    }
  },

  actions: {
    queryParamsDidChange: function(){
      this.refresh();
    }
  }
});
