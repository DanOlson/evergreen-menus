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
    const element = this.$()[0];
    const map = new google.maps.Map(element, this.mapOptions());

    this.$().css({
      width() {
        return Ember.$(window).width() * widthMultiplier;
      },
      height() {
        return Ember.$(window).height() * heightMultiplier;
      }
    });

    this.set('map', map);
    this.placeMarkers(map, establishments);
  },

  didReceiveAttrs() {
    this._super(...arguments);
    const map = this.get('map');
    const establishments = this.get('establishments');

    this.destroyMarkers();

    //////
    // Map would not exist yet on initial render, since didReceiveAttrs
    // preceeds didInsertElement in the component lifecycle.
    if (map) {
      this.placeMarkers(map, establishments);
    }
  },

  destroyMarkers() {
    this.get('markers').forEach(marker => marker.setMap(null));
  },

  placeMarkers(map, establishments) {
    const markers = this.get('markers');
    const bounds  = new google.maps.LatLngBounds();
    establishments.forEach(establishment => {
      const latLng = this.createLatLng(establishment);
      const marker = new google.maps.Marker({
        position:  latLng,
        animation: google.maps.Animation.DROP,
        map:       map,
        name:      establishment.get('name'),
        id:        establishment.get('id')
      });
      bounds.extend(latLng);
      markers.push(marker);
    });
    map.fitBounds(bounds);
  },

  createLatLng(establishment) {
    const lat = establishment.get('latitude');
    const lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  },
});
