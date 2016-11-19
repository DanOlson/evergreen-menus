import Ember from 'ember';
import MapUtils from '../mixins/map-utils';
// import flashQueueController from '../controllers/flash-queue';

var SearchController = Ember.Controller.extend(MapUtils, {
  applicationController: Ember.inject.controller('application'),
  query: Ember.computed.reads('applicationController.queryField'),
  queryParams: ['query']
});

export default SearchController;
