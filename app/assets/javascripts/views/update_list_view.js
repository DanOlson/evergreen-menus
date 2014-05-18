Beermapper.UpdateListView = Ember.View.extend({
  template: Ember.Handlebars.compile("Update List"),
  tagName: 'button',
  classNames: ['btn', 'btn-danger'],
  attributeBindings: ['isUpdating:disabled'],
  isUpdating: function(){
    return this.get('controller').get('updating')
  }.property('controller.updating'),

  click: function(e){
    this.get('controller').send('updateList');
  }
})
