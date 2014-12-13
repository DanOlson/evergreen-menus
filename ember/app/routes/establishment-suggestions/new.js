import Ember from 'ember';

var EstablishmentSuggestionsNewRoute = Ember.Route.extend({
  model: function(){
    return this.store.createRecord('establishment_suggestion');
  },
});

export default EstablishmentSuggestionsNewRoute;
