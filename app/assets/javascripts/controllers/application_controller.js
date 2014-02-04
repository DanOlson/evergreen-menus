Beermapper.ApplicationController = Ember.ObjectController.extend({
  query: null,
  queryField: Ember.computed.oneWay('query'),

  actions: {
    search: function(){
      this.transitionToRoute('search', {
        queryParams: {
          query: this.get('queryField')
        }
      });
    }
  }
})
