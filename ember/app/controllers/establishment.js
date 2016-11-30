import Ember from 'ember';
import flashQueueController from '../controllers/flash-queue';

const EstablishmentController = Ember.Controller.extend({
  applicationController: Ember.inject.controller('application'),
  isAuthenticated: Ember.computed.reads('applicationController.isAuthenticated'),

  actions: {
    updateList(establishment) {
      const listUpdate = this.store.createRecord('listUpdate', { establishment });
      return listUpdate.save().then(() => {
        flashQueueController.flash('notice', 'Beer list updated!');
      }).catch(() => {
        flashQueueController.flash('alert', 'Beer list was not updated!');
      });
    }
  }
});

export default EstablishmentController;
