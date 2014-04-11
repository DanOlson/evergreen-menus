Beermapper.ListUpdatesRoute = Beermapper.AuthenticatedRoute.extend({
  model: function(){
    return this.store.find('list_update');
  }
})
