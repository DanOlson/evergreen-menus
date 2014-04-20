Beermapper.EstablishmentRoute = Ember.Route.extend(Beermapper.ResetScroll, {
  model: function(params){
    return this.store.find('establishment', params.id);
  }
});
