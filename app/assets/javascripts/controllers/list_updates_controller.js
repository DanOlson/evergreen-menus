Beermapper.ListUpdatesController = Ember.ArrayController.extend({
  queryParams: ['startDate', 'endDate', 'status', 'establishmentId'],
  itemController: 'listUpdate',
  status: 'Any',
  statuses: ['Any', 'Success', 'Failed'],
  endDate: null,
  startDate: function(){
    var today, dd, mm, yyyy;
    today = new Date();
    mm    = today.getMonth() + 1;
    dd    = today.getDate();
    yyyy  = today.getFullYear();
    if (dd < 10){
      dd = '0' + dd
    }

    if (mm < 10){
      mm = '0' + mm
    }
    return yyyy + '-' + mm + '-' + dd
  }.property()
});
