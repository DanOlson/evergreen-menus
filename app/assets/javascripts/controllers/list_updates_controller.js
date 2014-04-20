Beermapper.ListUpdatesController = Ember.ArrayController.extend(Beermapper.DateFormatHelper, {
  queryParams: ['startDate', 'endDate', 'status', 'establishmentId'],
  itemController: 'listUpdate',
  status: 'Any',
  statuses: ['Any', 'Success', 'Failed'],
  endDate: function(){
    return this.dateString(new Date());
  }.property(),

  startDate: function(){
    var yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    return this.dateString(yesterday);
  }.property()
});
