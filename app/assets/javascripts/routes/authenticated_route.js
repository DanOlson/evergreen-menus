Beermapper.AuthenticatedRoute = Ember.Route.extend({
  afterModel: function(transition){
    if (!Beermapper.AuthManager.isAuthenticated()){
      this.redirectToLogin(transition);
    }
  },

  redirectToLogin: function(transition){
    var sessionsNewController = this.controllerFor('sessions.new');
    sessionsNewController.set('attemptedTransition', transition);
    this.transitionTo('sessions.new');
  },

  actions: {
    error: function(reason, transition){
      this.redirectToLogin(transition);
    }
  }
})
