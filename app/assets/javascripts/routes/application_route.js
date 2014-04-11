Beermapper.ApplicationRoute = Ember.Route.extend({
  init: function(){
    this._super();
    Beermapper.AuthManager = Beermapper.AuthManager.create();
  },

  actions: {
    logout: function(){
      Beermapper.AuthManager.reset();
      this.transitionTo('index');
    }
  }
})
