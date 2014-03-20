Beermapper.MapView = Ember.ContainerView.extend({
  didInsertElement: function(){
    var controller = this.get('controller');
    var map        = controller.createMap(this.$()[0]);
    var infoWindow = new google.maps.InfoWindow({maxWidth:300});

    // Size the view's container so that the map can render
    this.$().css({
      width: function(){
        return $(window).width() * controller.get('mapWidthMultiplier')
      },
      height: function(){
        return $(window).height() * controller.get('mapHeightMultiplier')
      }
    });

    controller.set('infoWindow', infoWindow);
    controller.set('map', map);
    controller.set('mapView', this);
    controller.placeMarkers(this);
  },

  childViews: []
});
