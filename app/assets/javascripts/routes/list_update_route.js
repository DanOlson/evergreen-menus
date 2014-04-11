Beermapper.ListUpdateRoute = Beermapper.AuthenticatedRoute.extend({
  model: function(params){
    return this.store.find('list_update', params.id);
  }
})
