Beermapper.EstablishmentSuggestionsController = Ember.ObjectController.extend({
  actions: {
    formSubmit: function(){
      var that = this;
      this.get('model').save().then(function(){
        that.transitionToRoute('index');
      }, function(){
        console.log("error creating suggestion");
      });
    },

    cancel: function(){
      this.transitionToRoute('index');
    }
  }
})
