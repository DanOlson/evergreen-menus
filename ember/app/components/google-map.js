import Ember from 'ember';

export default Ember.Component.extend({
  latitude: 44.983334,
  longitude: -93.266670,
  mapWidthMultiplier: 1.0,
  mapHeightMultiplier: 0.9,

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

    this.$().css({
      width() {
        return Ember.$(window).width() * widthMultiplier;
      },
      height() {
        return Ember.$(window).height() * heightMultiplier;
      }
    });

    const element = this.$()[0];
    new google.maps.Map(element, this.mapOptions());
  }
});
