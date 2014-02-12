Beermapper.SearchController = Ember.ArrayController.extend(Beermapper.MapUtils, {
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),
  itemController: 'establishment',

  bounds: function(){
    return new google.maps.LatLngBounds();
  },

  placeMarkers: function(mapView){
    console.log('[SearchController] placeMarkers()');
    this.clearMarkers();
    var bounds = this.get('bounds')();
    this.forEach(function(establishment){
      this.markers.push(establishment.marker(mapView));
      bounds.extend(establishment.latLng());
    }, this);
    this.get('map').fitBounds(bounds);
  }
});
