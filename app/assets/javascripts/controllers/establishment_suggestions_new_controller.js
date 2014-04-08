Beermapper.EstablishmentSuggestionsNewController = Ember.ObjectController.extend({
  actions: {
    formSubmit: function(){
      var that = this;
      var suggestion = this.content;
      var name = suggestion.get('name');
      var url  = suggestion.get('beerListUrl');

      if(!name || !url){
        if(!name){
          this.set('nameIsRequired', true);
          Beermapper.flashQueueController.flash('alert', 'Name is required');
        } else {
          this.set('nameIsRequired', false);
        }
        if(!url){
          this.set('urlIsRequired', true);
          Beermapper.flashQueueController.flash('alert', 'URL is required');
        } else {
          this.set('urlIsRequired', false);
        }
        return;
      }

      suggestion.save().then(function(){
        Beermapper.flashQueueController.flash('notice', 'Thanks for the suggestion!');
        that.transitionToRoute('index');
      }, function(reason){
        Beermapper.flashQueueController.flash('alert', 'Could not save suggestion');
      });
    },

    cancel: function(){
      this.transitionToRoute('index');
    }
  }
})
