Beermapper.EstablishmentDecorator = Ember.Object.extend({
  init: function(){
    this._super();
    this.set('latLng', this.makeLatLng(this.get('establishment')));
  },

  marker: function(map){
    var establishment = this.get('establishment');

    return new google.maps.Marker({
      position:  this.get('latLng'),
      animation: google.maps.Animation.DROP,
      map:       map,
      name:      establishment.get('name'),
      id:        establishment.get('id')
    });
  },

  makeLatLng: function(establishment){
    var lat = establishment.get('latitude');
    var lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  }
})
