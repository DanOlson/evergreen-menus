Beermapper.SearchController = Ember.ArrayController.extend(Beermapper.MapUtils, {
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),

  latitude: 44.983334,
  longitude: -93.266670,
  bounds: function(){
    return new google.maps.LatLngBounds();
  },

  placeMarkers: function(){
    this.clearMarkers();
    var bounds = this.get('bounds')();
    this.forEach(function(establishment){
      var map = this.get('map');
      var decorator = Beermapper.EstablishmentDecorator.create({establishment: establishment});
      this.markers.push(decorator.marker(map));
      bounds.extend(decorator.get('latLng'));
    }, this);
    this.get('map').fitBounds(bounds);
  }
});
