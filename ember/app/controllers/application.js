import Ember from 'ember';
import AuthManager from '../services/auth-manager';
import flashQueueController from '../controllers/flash-queue';

var ApplicationController = Ember.ObjectController.extend({
  query: null,
  queryField: Ember.computed.oneWay('query'),

  currentUser: function(){
    return AuthManager.get('apiKey.user');
  }.property('AuthManager.apiKey'),

  isAuthenticated: function(){
    return AuthManager.isAuthenticated();
  }.property('AuthManager.apiKey'),

  actions: {
    search: function(){
      // close the navbar if it's open
      Ember.$('.navbar-collapse').collapse('hide');
      this.transitionToRoute('search', {
        queryParams: {
          query: this.get('queryField')
        }
      });
    },

    logout: function(){
      AuthManager.reset();
      flashQueueController.flash('notice', 'You have logged out');
      this.transitionToRoute('index');
    }
  }
});

export default ApplicationController;
