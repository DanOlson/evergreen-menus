Beermapper.ListUpdateRoute = Beermapper.AuthenticatedRoute.extend(Beermapper.ResetScroll, {
  model: function(params){
    return this.store.find('list_update', params.id);
  }
})
