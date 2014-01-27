Beermapper.ApplicationController = Ember.Controller.extend({
  query: null,

  actions: {
    search: function(){
      this.transitionToRoute('search', {
        queryParams: {
          query: this.get('query')
        }
      });
    }
  }
})
