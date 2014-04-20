Beermapper.ListUpdateFilterView = Ember.View.extend({
  templateName: 'list_update_filters',
  tagName: 'form',
  classNames: ['form-inline'],

  didInsertElement: function(){
    this.$('.date-filter').datepicker({
      dateFormat: 'yy-mm-dd',
      maxDate: 0
    });
  }
})
