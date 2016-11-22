import Ember from 'ember';

export default Ember.Component.extend({
  latitude: 44.983334,
  longitude: -93.266670,
  infoWindow: new google.maps.InfoWindow({ maxWidth: 300 }),
  markers: Ember.A(),
  classNames: ['theMap'],

  mapOptions() {
    return {
      zoom: 11,
      center: new google.maps.LatLng(this.get('latitude'), this.get('longitude')),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
  },

  didInsertElement() {
    this._super();

    const element = this.$()[0];
    const bounds = new google.maps.LatLngBounds();
    const map = new google.maps.Map(element, this.mapOptions());

    this.set('map', map);
    this.set('bounds', bounds);
    this.placeMarkers(map, bounds);
  },

  didRender() {
    this._super(...arguments);
    // Can this just be done with CSS?
    const { widthMultiplier, heightMultiplier, zoom } = this.attrs;
    const map = this.get('map');
    const bounds = this.get('bounds');
    this.$().css({
      width() {
        return Ember.$(window).width() * widthMultiplier;
      },
      height() {
        return Ember.$(window).height() * heightMultiplier;
      }
    });
    google.maps.event.trigger(map, 'resize');
    map.fitBounds(bounds);
    if (zoom) {
      map.setZoom(zoom);
    }
  },

  registerMarker(marker) {
    this.get('markers').addObject(marker);
  },

  unregisterMarker(marker) {
    this.get('markers').removeObject(marker);
  },

  placeMarkers(map, bounds) {
    this.get('markers').forEach(marker => {
      marker.setMap(map);
      bounds.extend(marker.latLng());
    });
    map.fitBounds(bounds);
  }
});
