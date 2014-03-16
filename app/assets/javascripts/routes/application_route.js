Beermapper.ApplicationRoute = Ember.Route.extend({
  actions: {
    openModal: function(modalName){
      var controller = this.controllerFor(modalName);
      var resource   = controller.get('resource');
      var content    = this.store.find(resource)
      var modal      = Beermapper.ModalView.create({
        controller: controller,
        container: this.container,
        templateName: modalName
      });

      content.then(function(){
        controller.set('content', content);
        modal.append();
      })
    }
  }
})
