import Ember from 'ember';
// import flashQueueController from '../controllers/flash-queue';

export default Ember.Controller.extend({
  applicationController: Ember.inject.controller('application'),
  query: Ember.computed.reads('applicationController.queryField'),
  queryParams: ['query']
});
