Beermapper.IndexController = Ember.ObjectController.extend(Beermapper.MapUtils, {
  map: null,
  infoWindow: null,

  // Noop
  placeMarkers: function(){ console.log('[IndexController] placeMarkers()'); }
});
