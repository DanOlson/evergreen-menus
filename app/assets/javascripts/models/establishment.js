var attr = DS.attr;

Beermapper.Establishment = DS.Model.extend({
  name: attr(),
  address: attr(),
  url: attr(),
  latitude: attr(),
  longitude: attr()
});
