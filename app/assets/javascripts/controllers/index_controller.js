Beermapper.IndexController = Ember.ObjectController.extend(Beermapper.MapUtils, {
  map: null,
  infoWindow: null,
  mapWidthMultiplier: 0.9,
  mapHeightMultiplier: 0.9,

  // Noop
  placeMarkers: function(){}
});
