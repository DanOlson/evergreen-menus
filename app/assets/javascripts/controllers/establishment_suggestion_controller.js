Beermapper.EstablishmentSuggestionController = Ember.ObjectController.extend({
  actions: {
    destroy: function(){
      this.get('content').destroyRecord();
    }
  }
})