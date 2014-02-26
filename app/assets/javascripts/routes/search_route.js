Beermapper.SearchRoute = Ember.Route.extend({
  model: function(params){
    var query = params.query;
    if (!query) { return []; }
    return this.store.find('establishment', { beer: query });
  },

  afterModel: function(){
    var controller = this.controllerFor('search');
    var map = controller.get('map');
    console.log("[SearchRoute] afterModel");
    if (map.hasOwnProperty('mapTypeId')) {
      controller.placeMarkers(controller.get('mapView'));
    }
  },

  actions: {
    queryParamsDidChange: function(){
      console.log('[SearchRoute] queryParamsDidChange');
      this.refresh();
    }
  }
});
