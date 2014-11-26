import Ember from 'ember';

var EstablishmentSuggestionController = Ember.ObjectController.extend({
  actions: {
    destroy: function(){
      this.get('model').destroyRecord();
    }
  }
});

export default EstablishmentSuggestionController;
