Beermapper.EstablishmentsRoute = Ember.Route.extend({
  model: function(){
    return this.store.find('establishment');
  },

  actions: {
    loading: function(transition, originRoute){
      var view = Ember.View.create({
        container: this.container,
        controller: this.controllerFor('application'),
        templateName: 'global-loading',
        elementId: 'loading'
      }).append();

      this.router.one('didTransition', function() {
        view.destroy();
      });
      return false;
    }
  }
})
