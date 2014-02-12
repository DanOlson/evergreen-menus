Beermapper.EstablishmentController = Ember.ObjectController.extend({
  needs: 'search',
  map: Ember.computed.alias('controllers.search.map'),
  infoWindow: Ember.computed.alias('controllers.search.infoWindow'),

  marker: function(mapView){
    var establishment = this.get('model');
    var marker = new google.maps.Marker({
      position:  this.latLng(),
      animation: google.maps.Animation.DROP,
      map:       this.get('map'),
      name:      establishment.get('name'),
      id:        establishment.get('id')
    });

    this.addClickHandler(marker, mapView);

    return marker
  },

  addClickHandler: function(marker, containerView){
    var that = this;
    google.maps.event.addListener(marker, 'click', (function(marker) {
      return function() {
        var markerView = Beermapper.MarkerView.create({
          marker: marker,
          infoWindow: that.get('infoWindow'),
          map: that.get('map'),
          establishment: that.get('model')
        });
        containerView.set('currentView', markerView);
      }
    })(marker));
  },

  latLng: function(){
    var establishment = this.get('model');
    var lat = establishment.get('latitude');
    var lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  }
});
