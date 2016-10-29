import Ember from 'ember';

export default Ember.Component.extend({
  init: function() {
    console.log(`init()`);
    this._super.apply(this, arguments);
    console.log(`done with init`);
  },

  didReceiveAttrs: function() {
    console.log('didReceiveAttrs()');
    this._super();
  },

  didInsertElement: function(){
    console.log("Marker component: didInsertElement()");
    var infoWindow = this.get('infoWindow');

    infoWindow.setContent(this.$()[0]);
    infoWindow.open(this.get('map'), this.get('marker'));
  },

  willRender: function() {
    console.log(`willRender`);
    this._super();
  },

  didRender: function() {
    console.log(`didRender`);
    this._super();
  },

  name: function(){
    var establishment = this.get('establishment');
    return establishment.get('name');
  }.property('establishment'),

  beers: function(){
    var query = this.get('query');
    var filtered = this.get('establishment').get('beers').filter(function(beer){
      return beer.get('name').match(new RegExp(query, 'i'));
    });
    return filtered;
  }.property('establishment')
});
