Beermapper.HeaderView = Ember.View.extend({
  templateName: 'header',

  whatIsBeermapperView: Ember.View.extend({
    templateName: 'what_is_beermapper_button',
    tagName: 'li',
    click: function(event){
      event.preventDefault();
      $beermapper = this.get('parentView').$().find('.what-is-beermapper');
      if($beermapper.is(':visible')){
        $beermapper.slideUp('fast');
      } else {
        $beermapper.slideDown('fast');
      }
    }
  })
})
