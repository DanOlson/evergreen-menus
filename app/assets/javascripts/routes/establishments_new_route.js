Beermapper.EstablishmentsNewRoute = Beermapper.AuthenticatedRoute.extend({
  model: function(){
    return this.store.createRecord('establishment');
  },

  setupController: function(controller, model){
    this._super(controller, model);
    var scrapers = this.store.find('scraper').then(function(scrapers){
      controller.set('scrapers', scrapers);
    })
  }
});
