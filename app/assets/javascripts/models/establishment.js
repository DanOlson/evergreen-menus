var attr = DS.attr;

Beermapper.Establishment = DS.Model.extend({
  name: attr(),
  address: attr(),
  url: attr(),
  active: attr('boolean', { defaultValue: true }),
  latitude: attr(),
  longitude: attr(),

  beers: DS.hasMany('beer')
});
