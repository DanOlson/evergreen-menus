Beermapper.EstablishmentListController = Ember.ArrayController.extend({
  modalTitle: 'Establishments',
  resource: 'establishment',

  actions: {
    linkToEstablishment: function(establishment, modal){
      modal.close();
      this.transitionToRoute('establishment', establishment);
    }
  }
})
