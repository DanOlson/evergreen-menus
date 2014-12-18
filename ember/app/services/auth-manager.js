import Ember from 'ember';
import DS from 'ember-data';
import ApiKey from '../models/api-key';
import App from '../app';

var AuthManager = Ember.Object.extend({
  init: function(){
    this._super();
    var accessToken = Ember.$.cookie('access_token');
    var authUserId  = Ember.$.cookie('user_id');
    if(!Ember.isEmpty(accessToken) && !Ember.isEmpty(authUserId)){
      this.authenticate(accessToken, authUserId);
    }
  },

  isAuthenticated: function(){
    return !Ember.isEmpty(this.get('apiKey.accessToken')) && !Ember.isEmpty(this.get('apiKey.user'));
  },

  authenticate: function(accessToken, userId){
    Ember.$.ajaxSetup({
      headers: { 'Authorization': 'Bearer ' + accessToken }
    });
    var user = Beermapper.__container__.lookup('store:main').find('user', userId);
    var that = this;
    user.then(function(){
      that.set('apiKey', ApiKey.create({
        accessToken: accessToken,
        user: user.content
      }));
    }, function(){
      that.reset();
    });
  },

  reset: function(){
    Beermapper.__container__.lookup('route:application').transitionTo('sessions.new');
    Ember.run.sync();
    Ember.run.next(this, function(){
      this.set('apiKey', null);
      Ember.$.ajaxSetup({
        headers: { 'Authorization': 'Bearer none' }
      });
    });
  },

  apiKeyObserver: function(){
    if (Ember.isEmpty(this.get('apiKey'))){
      Ember.$.removeCookie('access_token');
      Ember.$.removeCookie('user_id');
    } else {
      Ember.run.next(this, function(){
        Ember.$.cookie('access_token', this.get('apiKey.accessToken'));
        Ember.$.cookie('user_id', this.get('apiKey.user.id'));
      });
    }
  }.observes('apiKey')
});

DS.rejectionHandler = function(reason) {
  if (reason.status === 401) {
    AuthManager.reset();
  }
  throw reason;
};

export default AuthManager.create();
