import Ember from 'ember';

var EstablishmentsIndexRoute = Ember.Route.extend({
  model: function(){
    return this.store.find('establishment');
  },

  actions: {
    loading: function(){
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
    },

    newEstablishment: function(){
      this.transitionTo('establishments.new');
    }
  }
});

export default EstablishmentsIndexRoute;
