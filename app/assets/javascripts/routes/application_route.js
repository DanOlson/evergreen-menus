Beermapper.ApplicationRoute = Ember.Route.extend({
  init: function(){
    this._super();
    Beermapper.AuthManager = Beermapper.AuthManager.create();
  },

  activate: function(){
    this._super();
    return Ember.run.next(function(){
      twttr.widgets.load();
    });
  },

  actions: {
    logout: function(){
      Beermapper.AuthManager.reset();
      this.transitionTo('index');
    }
  }
})
