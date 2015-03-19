import AuthenticatedRoute from '../authenticated';

var EstablishmentSuggestionsIndexRoute = AuthenticatedRoute.extend({
  model: function(){
    return this.store.find('establishment_suggestion');
  }
});

export default EstablishmentSuggestionsIndexRoute;