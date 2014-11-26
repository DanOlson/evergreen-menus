import DS from 'ember-data';

var attr = DS.attr;
var Establishment = DS.Model.extend({
  name: attr(),
  address: attr(),
  url: attr(),
  active: attr('boolean', { defaultValue: true }),
  latitude: attr(),
  longitude: attr(),

  beers: DS.hasMany('beer'),
  scraper: DS.belongsTo('scraper')
});

export default Establishment;
