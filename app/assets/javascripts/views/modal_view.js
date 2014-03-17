Beermapper.ModalView = Ember.View.extend({
  templateName: '',
  title: '',
  content: '',
  classNames: ["modal", "fade"],
  didInsertElement: function() {
    this.$().modal('show');
    this.$().one("hidden", this._viewDidHide);
  },
  // modal dismissed by example clicked in X, make sure the modal view is destroyed
  _viewDidHide: function() {
    if (!this.isDestroyed) {
      console.log("destroying ModalView");
      this.destroy();
    }
  },
  // here we click in close button so _viewDidHide is called
  close: function() {
    this.$(".close").click();
  }
});
