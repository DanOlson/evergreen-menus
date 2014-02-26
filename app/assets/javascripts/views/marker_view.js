Beermapper.MarkerView = Ember.View.extend({
  templateName: 'marker',

  didInsertElement: function(){
    var infoWindow = this.get('infoWindow');

    infoWindow.setContent(this.$()[0]);
    infoWindow.open(this.get('map'), this.get('marker'));
  },

  name: function(){
    var establishment = this.get('controller').get('model');
    return establishment.get('name');
  }.property('establishment'),

  beers: function(){
    var query = this.get('query');
    var filtered = this.get('establishment').get('beers').filter(function(beer){
      return beer.get('name').match(new RegExp(query, 'i'));
    });
    return filtered
  }.property('establishment')
});
