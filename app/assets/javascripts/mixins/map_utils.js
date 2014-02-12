Beermapper.MapUtils = Ember.Mixin.create({
  // templates
  latitude: 44.983334,
  longitude: -93.266670,

  markers: [],

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
    this.markers.forEach(function(marker){
      marker.setMap(null)
    });
  }
});
