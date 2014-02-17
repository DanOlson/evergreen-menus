Beermapper.MapView = Ember.ContainerView.create({
  didInsertElement: function(){
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
    var map        = controller.createMap(this.$()[0]);
    var infoWindow = new google.maps.InfoWindow({maxWidth:300});

    controller.set('infoWindow', infoWindow);
    controller.set('map', map);

    // Call this for Search, not Index
    if (typeof controller.placeMarkers === 'function'){
      controller.placeMarkers(this);
    }
  },

  childViews: []
});
