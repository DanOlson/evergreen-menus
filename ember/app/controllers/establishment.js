import Ember from 'ember';
import MapUtils from '../mixins/map-utils';
import MarkerView from '../components/map-marker';
import flashQueueController from '../controllers/flash-queue';

var EstablishmentController = Ember.Controller.extend(MapUtils, {
  searchController: Ember.inject.controller('search'),
  applicationController: Ember.inject.controller('application'),
  map: Ember.computed.reads('searchController.map'),
  query: Ember.computed.reads('searchController.query'),
  infoWindow: Ember.computed.reads('searchController.infoWindow'),
  isAuthenticated: Ember.computed.reads('applicationController.isAuthenticated'),
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
    var infoWindow = this.get('infoWindow');
    google.maps.event.addListener(marker, 'click', (marker => {
      return () => {
        var current = mapView.get('currentView');
        var markerView = MarkerView.create({
          marker:        marker,
          infoWindow:    infoWindow,
          map:           this.get('map'),
          establishment: this.get('model'),
          query:         this.get('query'),
          controller:    this
        });
        this.get('markerViews').pushObject(markerView);

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
