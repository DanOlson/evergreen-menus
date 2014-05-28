Beermapper.EstablishmentsNewRoute = Beermapper.AuthenticatedRoute.extend({
  model: function(){
    return this.store.createRecord('establishment');
  }
});
