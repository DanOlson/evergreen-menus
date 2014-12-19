import Ember from 'ember';
import MapUtils from '../mixins/map-utils';
import MarkerView from '../views/marker-view';
import flashQueueController from '../controllers/flash-queue';

var EstablishmentController = Ember.ObjectController.extend(MapUtils, {
  needs: ['search', 'application'],
  map: Ember.computed.alias('controllers.search.map'),
  query: Ember.computed.alias('controllers.search.query'),
  markerViews: Ember.computed.alias('controllers.search.markerViews'),
  infoWindow: Ember.computed.alias('controllers.search.infoWindow'),
  isAuthenticated: Ember.computed.alias('controllers.application.isAuthenticated'),
  mapWidthMultiplier: 0.5,
  mapHeightMultiplier: 0.8,
  updating: false,
  flashQueueController: flashQueueController,

  placeMarkers: function(mapView){
    var func = function(){
      var map = this.get('map');
      var bounds = new google.maps.LatLngBounds();
      var zoomChangeBoundsListener = google.maps.event.addListenerOnce(map, 'bounds_changed', function() {
        if (this.getZoom()){ this.setZoom(14); }
      });

      this.clearMarkers();
      this.get('markers').pushObject(this.marker(mapView, true));
      bounds.extend(this.latLng());
      map.fitBounds(bounds);
      setTimeout(function(){
        google.maps.event.removeListener(zoomChangeBoundsListener);
      }, 0);
    };
    return Ember.run.debounce(this, func, 250);
  },

  marker: function(mapView, skipClickHandler){
    var establishment = this.get('model');
    var marker = new google.maps.Marker({
      position:  this.latLng(),
      animation: google.maps.Animation.DROP,
      map:       this.get('map'),
      name:      establishment.get('name'),
      id:        establishment.get('id')
    });

    if(!skipClickHandler){
      this.addClickHandler(marker, mapView);
    }

    return marker;
  },

  addClickHandler: function(marker, mapView){
    var that = this;
    var infoWindow = that.get('infoWindow');
    google.maps.event.addListener(marker, 'click', (function(marker){
      return function(){
        var current = mapView.get('currentView');
        var markerView = MarkerView.create({
          marker:        marker,
          infoWindow:    infoWindow,
          map:           that.get('map'),
          establishment: that.get('model'),
          query:         that.get('query'),
          controller:    that
        });
        that.get('markerViews').pushObject(markerView);

        if(current){ mapView.removeChild(current); }

        mapView.set('currentView', markerView);
      };
    })(marker));
  },

  latLng: function(){
    var establishment = this.get('model');
    var lat = establishment.get('latitude');
    var lng = establishment.get('longitude');
    return new google.maps.LatLng(lat, lng);
  },

  actions: {
    transitionToDetails: function(){
      var establishment = this.get('model');
      establishment.reload();
      this.transitionToRoute('establishment', establishment);
    },

    updateList: function(){
      var that = this;
      var listUpdate = this.store.createRecord('listUpdate', {
        establishment: this.get('model')
      });
      this.set('updating', true);
      listUpdate.save().then(function(){
        flashQueueController.flash('notice', 'Beer list updated!');
        that.set('updating', false);
      }, function(){
        flashQueueController.flash('alert', 'Beer list was not updated!');
      });
    }
  }
});

export default EstablishmentController;
