Beermapper.SearchController = Ember.ArrayController.extend(Beermapper.MapUtils, {
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),

  latitude: 44.983334,
  longitude: -93.266670,

  placeMarkers: function(){
    var bounds = new google.maps.LatLngBounds();
    this.forEach(function(establishment){
      var lat = establishment.get('latitude');
      var lng = establishment.get('longitude')
      var latLng = new google.maps.LatLng(lat, lng);

      bounds.extend(latLng);
      return new google.maps.Marker({
        position:  latLng,
        animation: google.maps.Animation.DROP,
        map:       this.get('map'),
        name:      establishment.name,
        id:        establishment.id
      });
    }, this);
    this.get('map').fitBounds(bounds);
  }
});
