import Ember from 'ember';
import DateFormatHelper from '../mixins/date-format-helper';

var ListUpdatesController = Ember.ArrayController.extend(DateFormatHelper, {
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

export default ListUpdatesController;
