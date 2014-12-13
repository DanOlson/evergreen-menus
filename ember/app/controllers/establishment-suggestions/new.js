import Ember from 'ember';
import flashQueueController from '../flash-queue';

var EstablishmentSuggestionsNewController = Ember.ObjectController.extend({
  actions: {
    formSubmit: function(){
      var that = this;
      var suggestion = this.get('model');
      var name = suggestion.get('name');
      var url  = suggestion.get('beerListUrl');

      if(!name || !url){
        if(!name){
          this.set('nameIsRequired', true);
          flashQueueController.flash('alert', 'Name is required');
        } else {
          this.set('nameIsRequired', false);
        }
        if(!url){
          this.set('urlIsRequired', true);
          flashQueueController.flash('alert', 'URL is required');
        } else {
          this.set('urlIsRequired', false);
        }
        return;
      }

      suggestion.save().then(function(){
        flashQueueController.flash('notice', 'Thanks for the suggestion!');
        that.transitionToRoute('index');
      }, function(){
        flashQueueController.flash('alert', 'Could not save suggestion');
      });
    },

    cancel: function(){
      this.transitionToRoute('index');
    }
  }
});

export default EstablishmentSuggestionsNewController;
