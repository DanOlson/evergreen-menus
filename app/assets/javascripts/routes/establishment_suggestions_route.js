Beermapper.EstablishmentSuggestionsRoute = Ember.Route.extend({
  model: function(){
    return this.store.createRecord('establishment_suggestion');
  },

  renderTemplate: function(){
    this.render('new_establishment_suggestion');
  }
});
