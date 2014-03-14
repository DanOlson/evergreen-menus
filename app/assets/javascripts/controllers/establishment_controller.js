Beermapper.EstablishmentController = Ember.ObjectController.extend({
  needs: 'search',
  map: Ember.computed.alias('controllers.search.map'),
  query: Ember.computed.alias('controllers.search.query'),
  markerViews: Ember.computed.alias('controllers.search.markerViews'),
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

  addClickHandler: function(marker, mapView){
    var that = this;
    var infoWindow = that.get('infoWindow');
    google.maps.event.addListener(marker, 'click', (function(marker){
      return function(){
        var current = mapView.get('currentView');
        var markerView = Beermapper.MarkerView.create({
          marker:        marker,
          infoWindow:    infoWindow,
          map:           that.get('map'),
          establishment: that.get('model'),
          query:         that.get('query'),
          controller:    that
        });
        that.get('markerViews').pushObject(markerView);

        if(current){ mapView.removeChild(current); }

        mapView.set('currentView', markerView);
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
