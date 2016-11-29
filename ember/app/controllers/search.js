import Ember from 'ember';
import flashQueueController from '../controllers/flash-queue';

export default Ember.Controller.extend({
  applicationController: Ember.inject.controller('application'),
  query: Ember.computed.alias('applicationController.queryField'),
  queryParams: ['query'],

  actions: {
    noResults() {
      return flashQueueController.flash('alert', 'No results');
    }
  }
});
