import Ember from 'ember';
import FlashMessage from '../models/flash-message';

var flashQueueController = Ember.ArrayController.extend({
  destroyTimeout: 3 * 1e3, // 3s
  flash: function(type, message){
    var flash = FlashMessage.create({
      type: type,
      message: message,
      scheduledToDestroy: true,
      dismissable: false
    });
    this.pushObject(flash);

    if (flash.get('scheduledToDestroy')) {
      Ember.run.later(this, function(){
        this.removeObject(flash);
      }, this.destroyTimeout);
    }
  }
}).create();

export default flashQueueController;
