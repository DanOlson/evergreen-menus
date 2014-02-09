Beermapper.SearchController = Ember.ArrayController.extend(Beermapper.MapUtils, {
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),

  latitude: 44.983334,
  longitude: -93.266670,

  itemController: 'establishment',

  bounds: function(){
    return new google.maps.LatLngBounds();
  },

  placeMarkers: function(){
    this.clearMarkers();
    var bounds = this.get('bounds')();
    this.forEach(function(establishment){
      this.markers.push(establishment.marker());
      bounds.extend(establishment.latLng());
    }, this);
    this.get('map').fitBounds(bounds);
  }
});
