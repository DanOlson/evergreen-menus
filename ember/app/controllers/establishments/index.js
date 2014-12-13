import Ember from 'ember';

var EstablishmentsIndexController = Ember.ArrayController.extend({
  needs: 'application',
  isAuthenticated: Ember.computed.alias('controllers.application.isAuthenticated')
});

export default EstablishmentsIndexController;
