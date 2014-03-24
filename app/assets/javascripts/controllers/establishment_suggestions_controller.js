Beermapper.EstablishmentSuggestionsController = Ember.ObjectController.extend({
  actions: {
    formSubmit: function(){
      var that = this;
      this.get('model').save().then(function(){
        Beermapper.flashQueueController.flash('notice', 'Thanks for the suggestion!');
        that.transitionToRoute('index');
      }, function(){
        Beermapper.flashQueueController.flash('alert', 'We could not accept your suggestion at this time.');
      });
    },

    cancel: function(){
      this.transitionToRoute('index');
    }
  }
})
