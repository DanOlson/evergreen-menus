Beermapper.EstablishmentsIndexController = Ember.ArrayController.extend({
  needs: 'application',
  isAuthenticated: Ember.computed.alias('controllers.application.isAuthenticated')
})
