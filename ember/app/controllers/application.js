import Ember from 'ember';
import AuthManager from '../services/auth-manager';
import flashQueueController from '../controllers/flash-queue';

var ApplicationController = Ember.ObjectController.extend({
  query: Ember.computed.oneWay('queryField'),
  queryField: null,
  authManager: AuthManager,
  flashQueueController: flashQueueController,

  currentUser: function(){
    return AuthManager.get('apiKey.user');
  }.property('authManager.apiKey'),

  isAuthenticated: function(){
    return AuthManager.isAuthenticated();
  }.property('authManager.apiKey'),

  actions: {
    search: function(query){
      // close the navbar if it's open
      Ember.$('.navbar-collapse').collapse('hide');
      this.transitionToRoute('search', {
        queryParams: {
          query: query
        }
      });
    },

    logout: function(){
      AuthManager.set('applicationRoute', (AuthManager.applicationRoute || this));
      AuthManager.reset();
      flashQueueController.flash('notice', 'You have logged out');
      this.transitionToRoute('index');
    }
  }
});

export default ApplicationController;
