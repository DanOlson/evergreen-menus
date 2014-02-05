Beermapper.SearchController = Ember.ArrayController.extend({
  needs: 'application',
  queryParams: ['query'],
  query: Ember.computed.alias('controllers.application.queryField'),

  placeMarkers: function(){
    console.log("placing Markers");
  }
});
