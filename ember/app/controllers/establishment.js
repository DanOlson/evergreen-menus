import Ember from 'ember';
import flashQueueController from '../controllers/flash-queue';

const EstablishmentController = Ember.Controller.extend({
  applicationController: Ember.inject.controller('application'),
  isAuthenticated: Ember.computed.reads('applicationController.isAuthenticated'),
  updating: false,
  flashQueueController: flashQueueController,

  actions: {
    updateList: function(){
      const listUpdate = this.store.createRecord('listUpdate', {
        establishment: this.get('model')
      });
      this.set('updating', true);
      listUpdate.save().then(() => {
        flashQueueController.flash('notice', 'Beer list updated!');
        this.set('updating', false);
      }).catch(() => {
        flashQueueController.flash('alert', 'Beer list was not updated!');
      });
    }
  }
});

export default EstablishmentController;
