Beermapper.MapView = Ember.View.extend({
  didInsertElement: function(){
    console.log("[MapView] didInsertElement");
    // Size the view so that the map can render
    this.$().css({
      width: function(){
        return $(window).width() * 0.9
      },
      height: function(){
        return $(window).height() * 0.9
      }
    });

    var controller = this.get('controller');
    var map = controller.map(this.$()[0]);

    controller.set('map', map);

    // Call this for Search, not Index
    if (typeof controller.placeMarkers === 'function'){
      controller.placeMarkers();
    }
  }
});
