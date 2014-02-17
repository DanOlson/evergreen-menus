Beermapper.MarkerView = Ember.View.extend({
  templateName: 'marker',

  didInsertElement: function(){
    var infoWindow = this.get('infoWindow');

    infoWindow.setContent(this.$()[0]);
    infoWindow.open(this.get('map'), this.get('marker'));
  },

  name: function(){
    return this.get('establishment').get('name');
  }.property('establishment'),

  beers: function(){
    return this.get('establishment').get('beers').get('content');
  }.property('establishment')
});
