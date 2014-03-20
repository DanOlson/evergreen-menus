Beermapper.EstablishmentsRoute = Ember.Route.extend({
  model: function(){
    return this.store.find('establishment');
  }
})
