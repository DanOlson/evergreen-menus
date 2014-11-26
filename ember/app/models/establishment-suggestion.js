import DS from 'ember-data';

var EstablishmentSuggestion = DS.Model.extend({
  name: DS.attr(),
  beerListUrl: DS.attr()
});

export default EstablishmentSuggestion;
