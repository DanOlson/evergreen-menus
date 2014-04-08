Beermapper.ApplicationController = Ember.ObjectController.extend({
  query: null,
  queryField: Ember.computed.oneWay('query'),

  currentUser: function(){
    return Beermapper.AuthManager.get('apiKey.user');
  }.property('Beermapper.AuthManager.apiKey'),

  isAuthenticated: function(){
    return Beermapper.AuthManager.isAuthenticated()
  }.property('Beermapper.AuthManager.apiKey'),

  actions: {
    search: function(){
      this.transitionToRoute('search', {
        queryParams: {
          query: this.get('queryField')
        }
      });
    },

    logout: function(){
      Beermapper.AuthManager.reset();
      Beermapper.flashQueueController.flash('notice', 'You have logged out');
      this.transitionToRoute('index');
    }
  }
})
