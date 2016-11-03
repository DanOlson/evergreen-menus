import Ember from 'ember';

export default Ember.Component.extend({
  latitude: 44.983334,
  longitude: -93.266670,
  mapWidthMultiplier: 1.0,
  mapHeightMultiplier: 0.9,
  markers: [],
  map: null,

  mapOptions() {
    return {
      zoom: 11,
      center: new google.maps.LatLng(this.get('latitude'), this.get('longitude')),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
  },

  didInsertElement() {
    this._super(...arguments);

    const { widthMultiplier, heightMultiplier } = this.attrs;
    const establishments = this.get('establishments') || [];

    this.$().css({
      width() {
        return Ember.$(window).width() * widthMultiplier;
      },
      height() {
        return Ember.$(window).height() * heightMultiplier;
      }
    });

    const element = this.$()[0];
    const map = new google.maps.Map(element, this.mapOptions());
    this.set('map', map);
    this.placeMarkers(map, establishments);
  },

  didReceiveAttrs() {
    this._super(...arguments);
    const map = this.get('map');
    const establishments = this.get('establishments');

    this.destroyMarkers();
    this.placeMarkers(map, establishments);
  },

  destroyMarkers() {
    this.get('markers').forEach(marker => marker.setMap(null));
  },

  placeMarkers(map, establishments) {
    const markers = this.get('markers');
    establishments.forEach(establishment => {
      const marker = new google.maps.Marker({
        position:  this.latLng(establishment),
        animation: google.maps.Animation.DROP,
        map:       map,
        name:      establishment.get('name'),
        id:        establishment.get('id')
      });
      markers.push(marker);
    });
  },

  latLng(establishment) {
    const lat = establishment.get('latitude');
    const lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  },
});
