Beermapper.ListUpdateDateSelectView = Ember.View.extend({
  templateName: 'list_update_date_select',
  classNames: ['form-group'],

  didInsertElement: function(){
    this.$('.list-update-date-filter').datepicker({
      dateFormat: 'yy-mm-dd'
    });
  },
  
  change: function(){
    var startDate, endDate, controller;
    startDate  = this.$('.list-update-date-filter').val();
    endDate    = this.$('.list-update-date-filter').val();
    controller = this.get('controller');
    controller.set('startDate', startDate);
    controller.set('endDate', endDate);
  }
})
