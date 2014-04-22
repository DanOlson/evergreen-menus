Beermapper.AuthManager = Ember.Object.extend({
  init: function(){
    this._super();
    var accessToken = $.cookie('access_token');
    var authUserId  = $.cookie('user_id');
    if(!Ember.isEmpty(accessToken) && !Ember.isEmpty(authUserId)){
      this.authenticate(accessToken, authUserId);
    }
  },

  isAuthenticated: function(){
    return !Ember.isEmpty(this.get('apiKey.accessToken')) && !Ember.isEmpty(this.get('apiKey.user'));
  },

  authenticate: function(accessToken, userId){
    $.ajaxSetup({
      headers: { 'Authorization': 'Bearer ' + accessToken }
    });
    var user = Beermapper.__container__.lookup('store:main').find('user', userId);
    var that = this;
    user.then(function(){
      that.set('apiKey', Beermapper.ApiKey.create({
        accessToken: accessToken,
        user: user
      }));
    }, function(err){
      that.reset();
    });
  },

  reset: function(){
    Beermapper.__container__.lookup('route:application').transitionTo('sessions.new');
    Ember.run.sync();
    Ember.run.next(this, function(){
      this.set('apiKey', null);
      $.ajaxSetup({
        headers: { 'Authorization': 'Bearer none' }
      });
    });
  },

  apiKeyObserver: function(){
    if (Ember.isEmpty(this.get('apiKey'))){
      $.removeCookie('access_token');
      $.removeCookie('user_id');
    } else {
      Ember.run.next(this, function(){
        $.cookie('access_token', this.get('apiKey.accessToken'));
        $.cookie('user_id', this.get('apiKey.user.id'));
      });
    }
  }.observes('apiKey')
});

DS.rejectionHandler = function(reason) {
  if (reason.status === 401) {
    App.AuthManager.reset();
  }
  throw reason;
};
