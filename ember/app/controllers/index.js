import Ember from 'ember';
import MapUtils from '../mixins/map-utils';

var IndexController = Ember.ObjectController.extend(MapUtils, {
  map: null,
  infoWindow: null,
  mapWidthMultiplier: 1.0,
  mapHeightMultiplier: 0.9,

  // Noop
  placeMarkers: function(){}
});

export default IndexController;
