Beermapper.SearchController = Ember.ArrayController.extend(Beermapper.MapUtils, {
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),
  itemController: 'establishment',
  mapWidthMultiplier: 0.9,
  mapHeightMultiplier: 0.9,

  numResults: function(){
    return this.get('content').get('length');
  }.property('content.@each'),

  isEmpty: function(){
    return this.get('numResults') == 0
  }.property('numResults'),

  placeMarkers: function(mapView){
    var func = function(){
      console.log('[SearchController] placeMarkers()');
      this.clearMarkers();
      if(this.get('isEmpty')){
        return Beermapper.flashQueueController.flash('alert', 'No Results');
      }
      var bounds = new google.maps.LatLngBounds();
      this.forEach(function(establishment){
        this.get('markers').pushObject(establishment.marker(mapView));
        bounds.extend(establishment.latLng());
      }, this);
      this.get('map').fitBounds(bounds);
    }
    return Ember.run.debounce(this, func, 250);
  }
});
