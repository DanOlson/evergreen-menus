Beermapper.EstablishmentSuggestionsNewRoute = Ember.Route.extend({
  model: function(){
    return this.store.createRecord('establishment_suggestion');
  },
});
