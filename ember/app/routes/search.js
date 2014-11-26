import Ember from 'ember';

var SearchRoute = Ember.Route.extend({
  model: function(params){
    var query = params.query;
    if (!query) { return []; }
    return this.store.find('establishment', { beer: query });
  },

  afterModel: function(){
    var controller = this.controllerFor('search');
    var map = controller.get('map');
    if (map.hasOwnProperty('mapTypeId')) {
      controller.placeMarkers(controller.get('mapView'));
    }
  },

  actions: {
    queryParamsDidChange: function(){
      this.refresh();
    }
  }
});

export default SearchRoute;
