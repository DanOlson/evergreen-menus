Beermapper.MapUtils = Ember.Mixin.create({
  // templates
  latitude: 44.983334,
  longitude: -93.266670,

  markers: Ember.A(),
  markerViews: Ember.A(),
  mapView: null,
  infoWindow: '',

  mapOptions: function(){
    return {
      zoom: 11,
      center: new google.maps.LatLng(this.get('latitude'), this.get('longitude')),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
  },

  createMap: function(el){
    return new google.maps.Map(el, this.mapOptions());
  },

  clearMarkers: function(){
    this.get('markerViews').forEach(function(markerView){
      markerView.destroy();
    });
    this.get('markers').forEach(function(marker){
      marker.setMap(null);
    });
  }
});
