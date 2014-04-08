Beermapper.Router.map(function() {
  this.route('search');
  this.route('authenticated');
  this.resource('establishments');
  this.resource('establishment', { path: 'establishment/:id' });
  this.resource('establishment_suggestions', function(){
    this.route('new');
  });
  this.resource('sessions', function(){
    this.route('new');
  });
});

Beermapper.Router.reopen({
  didTransition: function(infos){
    this._super(infos);
    if(window.ga === undefined){ return; }

    Ember.run.next(function(){
      ga('send', 'pageview', window.location.hash.substring(1));
    });
  }
})
