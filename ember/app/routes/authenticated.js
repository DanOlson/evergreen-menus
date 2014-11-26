import Ember from 'ember';
import AuthManager from '../services/auth-manager';

var AuthenticatedRoute = Ember.Route.extend({
  afterModel: function(transition){
    if (!AuthManager.isAuthenticated()){
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
});

export default AuthenticatedRoute;
