Beermapper.ListUpdate = DS.Model.extend({
  name: DS.attr(),
  status: DS.attr(),
  notes: DS.attr(),
  rawData: DS.attr(),
  establishment: DS.belongsTo('establishment'),
  createdAt: DS.attr('date')
})
