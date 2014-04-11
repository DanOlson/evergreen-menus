Beermapper.ListUpdateController = Ember.ObjectController.extend({
  isFailure: function(){
    return this.get('status') == 'Failed'
  }.property(),

  scrapedList: function(){
    return JSON.parse(this.get('rawData')).list
  }.property('content'),

  listSize: function(){
    return this.get('scrapedList').length
  }.property('content'),

  actions: {
    viewListUpdate: function(listUpdate){
      this.transitionToRoute('list_update', listUpdate);
    }
  }
})
