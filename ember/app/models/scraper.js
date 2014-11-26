import DS from 'ember-data';

var Scraper = DS.Model.extend({
  establishment: DS.belongsTo('establishment'),
  scraperClassName: DS.attr(),
  lastRanAt: DS.attr('date'),
  scheduledRunTime: DS.attr('date')
});

export default Scraper;
