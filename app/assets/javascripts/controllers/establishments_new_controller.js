Beermapper.EstablishmentsNewController = Ember.ObjectController.extend({
  actions: {
    formSubmit: function(){
      var that = this;
      var establishment = this.content;
      establishment.save().then(function(){
        Beermapper.flashQueueController.flash('notice', 'Establishment created!');
        that.transitionToRoute('establishment', establishment);
      }, function(reason){
        Beermapper.flashQueueController.flash('alert', 'Could not save establishment');
      });
    },

    cancel: function(){
      this.transitionToRoute('establishments');
    }
  }
});
