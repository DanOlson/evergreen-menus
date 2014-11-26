import Ember from 'ember';

var MapView = Ember.ContainerView.extend({
  didInsertElement: function(){
    var controller = this.get('controller');
    var infoWindow = new google.maps.InfoWindow({maxWidth:300});

    // Size the view's container so that the map can render
    this.$().css({
      width: function(){
        return Ember.$(window).width() * controller.get('mapWidthMultiplier');
      },
      height: function(){
        return Ember.$(window).height() * controller.get('mapHeightMultiplier');
      }
    });

    var map = controller.createMap(this.$()[0]);
    controller.set('infoWindow', infoWindow);
    controller.set('map', map);
    controller.set('mapView', this);
    controller.placeMarkers(this);
  },

  childViews: []
});

export default MapView;
