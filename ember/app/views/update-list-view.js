import Ember from 'ember';

var UpdateListView = Ember.View.extend({
  template: Ember.Handlebars.compile("Update List"),
  tagName: 'button',
  classNames: ['btn', 'btn-danger'],
  attributeBindings: ['isUpdating:disabled'],
  isUpdating: function(){
    return this.get('controller').get('updating');
  }.property('controller.updating'),

  click: function(){
    this.get('controller').send('updateList');
  }
});

export default UpdateListView;
