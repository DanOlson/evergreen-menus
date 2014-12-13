import AuthenticatedRoute from '../authenticated';

var EstablishmentsNewRoute = AuthenticatedRoute.extend({
  model: function(){
    return this.store.createRecord('establishment');
  },

  setupController: function(controller, model){
    this._super(controller, model);
    this.store.find('scraper').then(function(scrapers){
      controller.set('scrapers', scrapers);
    });
  }
});

export default EstablishmentsNewRoute;
