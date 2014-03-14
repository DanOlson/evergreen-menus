Beermapper.EstablishmentListController = Ember.ArrayController.extend({
  actions: {
    close: function(){
      return this.send('closeModal');
    }
  }
})
