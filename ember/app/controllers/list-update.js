import Ember from 'ember';

var ListUpdateController = Ember.ObjectController.extend({
  isFailure: function(){
    return this.get('status') === 'Failed';
  }.property(),

  scrapedList: function(){
    return JSON.parse(this.get('rawData')).list;
  }.property('model'),

  listSize: function(){
    return this.get('scrapedList').length;
  }.property('model'),

  actions: {
    viewListUpdate: function(listUpdate){
      this.transitionToRoute('list_update', listUpdate);
    }
  }
});

export default ListUpdateController;
