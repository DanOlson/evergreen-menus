Beermapper.EstablishmentRoute = Ember.Route.extend({
  model: function(params){
    return this.store.find('establishment', params.id);
  }
});
