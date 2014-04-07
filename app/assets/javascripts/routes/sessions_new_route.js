Beermapper.SessionsNewRoute = Ember.Route.extend({
  model: function(){
    return Ember.Object.create();
  },

  actions: {
    loginUser: function(){
      var data = this.controllerFor('sessions.new').getProperties('username', 'password');
      var that = this;
      var authManager = Beermapper.AuthManager;

      $.post('/api/v1/sessions', data).then(function(response){
        authManager.authenticate(response.api_key.access_token, response.api_key.user_id);
        Ember.run.next(that, function(){
          Beermapper.flashQueueController.flash('notice', 'Welcome, ' + authManager.get('apiKey.user').get('name'));
          this.transitionTo('index');
        })
      }, function(){
        Beermapper.flashQueueController.flash('alert', 'Login failed');
      });
    }
  }
})
