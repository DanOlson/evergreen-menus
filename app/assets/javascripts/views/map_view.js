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
    var latitude   = controller.get('latitude');
    var longitude  = controller.get('longitude');
    var options    = {
      zoom: 11,
      center: new google.maps.LatLng(latitude, longitude),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }

    var map = new google.maps.Map(this.$()[0], options);
    this.set('map', map);

    // Call this for Search, not Index
    if (typeof controller.placeMarkers === 'function'){
      controller.placeMarkers();
    }
  }
});
