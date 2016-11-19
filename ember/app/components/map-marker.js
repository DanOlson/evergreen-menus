import Ember from 'ember';

export default Ember.Component.extend({
  infoWindow: null,
  mapContext: null,
  marker: null,

  didInsertElement() {
    this._super(arguments);
    this.set('marker', this.createMarker());
    this.get('mapContext').registerMarker(this);
  },

  willDestroyElement() {
    this._super();
    this.setMap(null);
    this.get('mapContext').unregisterMarker(this);
  },

  setMap(map) {
    this.get('marker').setMap(map);
  },

  estName() {
    return this.get('establishment').get('name');
  },

  createMarker() {
    const establishment = this.get('establishment');
    const latLng = this.latLng();
    return new google.maps.Marker({
      position:  latLng,
      animation: google.maps.Animation.DROP,
      name:      establishment.get('name'),
      id:        establishment.get('id')
    });
  },

  latLng() {
    const establishment = this.get('establishment');
    const lat = establishment.get('latitude');
    const lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  },

  name: function(){
    const establishment = this.get('establishment');
    return establishment.get('name');
  }.property('establishment'),

  beers: function(){
    const query = this.get('query');
    const filtered = this.get('establishment').get('beers').filter(function(beer){
      return beer.get('name').match(new RegExp(query, 'i'));
    });
    return filtered;
  }.property('establishment')
});
