Beermapper.EstablishmentsNewController = Ember.ObjectController.extend({
  scrapers: null,

  scraperClassName: function(){
    var scraper = this.get('scraper');
    if (scraper){
      return scraper.get('scraperClassName');
    }
  }.property('scraper'),

  scheduledRunTime: function(){
    var scraper = this.get('scraper');
    if (scraper){
      return scraper.get('scheduledRunTime');
    }
  }.property('scraper'),

  actions: {
    formSubmit: function(){
      var that = this;
      var establishment = this.get('model');
      // Beermapper.EstablishmentValidator = Ember.Object.extend({
      //   establishment: null,

      //   name: function(){
      //     return establishment.get('name')
      //   }.property(establishment),

      //   url: function(){
      //     return establishment.get('url')
      //   }.property(establishment),

      //   address: function(){
      //     establishment.get('address')
      //   }.property(establishment)
      // });
      // var validator = Beermapper.EstablishmentValidator.create({
      //   establishment: establishment
      // });

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
