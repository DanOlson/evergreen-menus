import Ember from 'ember';
import AuthManager from '../../services/auth-manager';
import flashQueueController from '../flash-queue';

var SessionsNewController = Ember.ObjectController.extend({
  attemptedTransition: null,
  flashQueueController: flashQueueController,

  actions: {
    loginUser: function(){
      var data = this.getProperties('username', 'password');
      var that = this;
      var attemptedTransition = this.get('attemptedTransition');

      Ember.$.post('/api/v1/sessions', data).then(function(response){
        AuthManager.set('store', that.store);
        AuthManager.set('applicationRoute', this.applicationRoute);
        AuthManager.authenticate(response.api_key.access_token, response.api_key.user_id);
        Ember.run.later(that, function(){
          flashQueueController.flash('notice', 'Welcome, ' + AuthManager.get('apiKey.user').get('name'));
          if (attemptedTransition){
            attemptedTransition.retry();
            this.set('attemptedTransition', null);
          } else {
            this.transitionToRoute('index');
          }
        }, 100);
      }, function(){
        flashQueueController.flash('alert', 'Login failed');
      });
    }
  }
});

export default SessionsNewController;
