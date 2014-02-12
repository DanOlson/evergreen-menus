Beermapper.Beer = DS.Model.extend({
  establishment: DS.belongsTo('establishment'),
  name: DS.attr()
});
