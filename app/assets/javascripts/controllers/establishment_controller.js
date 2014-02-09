Beermapper.EstablishmentController = Ember.ObjectController.extend({
  needs: 'search',
  map: Ember.computed.alias('controllers.search.map'),

  marker: function(){
    var establishment = this.get('model');
    var marker = new google.maps.Marker({
      position:  this.latLng(),
      animation: google.maps.Animation.DROP,
      map:       this.get('map'),
      name:      establishment.get('name'),
      id:        establishment.get('id')
    });

    google.maps.event.addListener(marker, 'click', (function(marker) {
      return function() {
        console.log('clicked:', marker);
        var view = Beermapper.MarkerView.create({marker: marker});
        // view.appendTo($('.body-container'));
      }
    })(marker));

    return marker
  },

  latLng: function(){
    var establishment = this.get('model');
    var lat = establishment.get('latitude');
    var lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  }
});
