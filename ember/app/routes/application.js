import Ember from 'ember';
import AuthManager from '../services/auth-manager';

var ApplicationRoute = Ember.Route.extend({
  init: function(){
    this._super();
  },

  activate: function(){
    this._super();
    return Ember.run.next(function(){
      twttr.widgets.load();
    });
  },

  actions: {
    logout: function(){
      AuthManager.reset();
      this.transitionTo('index');
    }
  }
});

export default ApplicationRoute;
