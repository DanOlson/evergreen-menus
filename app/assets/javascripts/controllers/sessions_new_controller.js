Beermapper.SessionsNewController = Ember.ObjectController.extend({
  attemptedTransition: null,

  actions: {
    loginUser: function(){
      var data = this.getProperties('username', 'password');
      var that = this;
      var authManager = Beermapper.AuthManager;
      var attemptedTransition = this.get('attemptedTransition');

      $.post('/api/v1/sessions', data).then(function(response){
        authManager.authenticate(response.api_key.access_token, response.api_key.user_id);
        Ember.run.later(that, function(){
          Beermapper.flashQueueController.flash('notice', 'Welcome, ' + authManager.get('apiKey.user').get('name'));
          if (attemptedTransition){
            attemptedTransition.retry();
            this.set('attemptedTransition', null);
          } else {
            this.transitionToRoute('index');
          }
        }, 100);
      }, function(){
        Beermapper.flashQueueController.flash('alert', 'Login failed');
      });
    }
  }
})
