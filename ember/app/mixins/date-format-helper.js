import Ember from 'ember';

var DateFormatHelper = Ember.Mixin.create({
  dateString: function(date){
    var dd, mm, yyyy;
    mm    = date.getMonth() + 1;
    dd    = date.getDate();
    yyyy  = date.getFullYear();
    if (dd < 10){
      dd = '0' + dd;
    }

    if (mm < 10){
      mm = '0' + mm;
    }
    return yyyy + '-' + mm + '-' + dd;
  }
});

export default DateFormatHelper;
