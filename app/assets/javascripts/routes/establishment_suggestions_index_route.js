Beermapper.EstablishmentSuggestionsIndexRoute = Beermapper.AuthenticatedRoute.extend({
  model: function(){
    return this.store.find('establishment_suggestion');
  }
})
