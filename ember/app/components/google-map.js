import Ember from 'ember';

const DEFAULT_ZOOM = 11;

export default Ember.Component.extend({
  latitude: 44.983334,
  longitude: -93.266670,
  infoWindow: new google.maps.InfoWindow({ maxWidth: 300 }),
  markers: Ember.A(),
  classNames: ['theMap'],

  mapOptions() {
    return {
      zoom: this.getZoom(),
      center: new google.maps.LatLng(this.get('latitude'), this.get('longitude')),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
  },

  getZoom() {
    return this.attrs.zoom || DEFAULT_ZOOM;
  },

  didInsertElement() {
    this._super();

    const element = this.$()[0];
    const bounds  = new google.maps.LatLngBounds();
    const map     = new google.maps.Map(element, this.mapOptions());

    this.set('map', map);
    this.set('bounds', bounds);
    this.placeMarkers();
  },

  didRender() {
    this._super(...arguments);
    // Can this just be done with CSS?
    const { widthMultiplier, heightMultiplier } = this.attrs;
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
  },

  registerMarker(marker) {
    this.get('markers').addObject(marker);
    this.placeMarkers();
  },

  unregisterMarker(marker) {
    this.get('markers').removeObject(marker);
    this.placeMarkers();
  },

  placeMarkers() {
    const map    = this.get('map');
    const bounds = this.get('bounds');

    if (map && bounds) {
      this.get('markers').forEach(marker => {
        marker.setMap(map);
        bounds.extend(marker.latLng());
      });
      map.fitBounds(bounds);
      this.applyBoundsChangedListener(map);
    }
  },

  applyBoundsChangedListener(map) {
    const zoom = this.getZoom();
    const onBoundsChanged = function onBoundsChanged() {
      // This is _not_ the getZoom() defined above
      if (this.getZoom()){
        this.setZoom(zoom);
      }
    };
    google.maps.event.addListenerOnce(map, 'bounds_changed', onBoundsChanged);
  }
});
