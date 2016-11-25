import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    search() {
      this.sendAction('action', this.get('queryField'));
    },

    toggleWhatIsBeermapper() {
      const $beermapper = this.$().find('.what-is-beermapper');
      if($beermapper.is(':visible')) {
        $beermapper.slideUp('fast');
      } else {
        $beermapper.slideDown('fast');
      }
    }
  }
});
