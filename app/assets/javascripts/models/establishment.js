var attr = DS.attr;

Beermapper.Establishment = DS.Model.extend({
  name: attr(),
  address: attr(),
  url: attr(),
  latitude: attr(),
  longitude: attr(),

  latLng: function(){
    return [this.get('latitude'), this.get('longitude')];
  }
});
