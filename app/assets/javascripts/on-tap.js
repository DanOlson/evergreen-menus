var onTap = {

  markers: [],
  infowindow: new google.maps.InfoWindow({maxWidth:300}),
  directionsService: new google.maps.DirectionsService(),
  directionsDisplay: new google.maps.DirectionsRenderer(),

  init: function(){
    this.setMap();
    this.initSearch();
    this.initDirectionsForm();
    this.initGetDirections();
    this.initGetSources();
    this.initShowEstablishment();
    this.initSuggestions();
    this.initSuggestionsForm();
    this.initWhatIsBeermapper();

    $('input#beer').focus();
  },

  initSearch: function(){
    var that = this;
    $('form#beer-search').submit(function(e){
      e.preventDefault();
      var $input = $('input#beer');
      var beer = $input.val();
      if (beer.length === 0){
        that.flashError('Please enter a search term');
      } else {
        $input.blur();
        that.sendRequest(beer);
      }
    });
  },

  initDirectionsForm: function(){
    var that = this;
    $('body').on('click', 'a.js-get-directions', function(e){
      e.preventDefault();
      var destination = $(this).data('position');
      var $req = $.get('/directions');
      $req.then(function(data){
        that.setModalContent(data);
      });
      $req.then(function(){
        $('input#end').val(destination);
        that.openModal({title: 'Get Directions'});
      })
    });
  },

  initGetDirections: function(){
    var that = this;
    $('body').on('submit', 'form.directions', function(e){
      e.preventDefault();
      that.getDirections();
    });
  },

  initGetSources: function(){
    var that = this;
    $('#js-get-sources').click(function(e){
      e.preventDefault();
      var $req = $.get('/sources');
      $req.done(function(data){
        that.setModalContent(data);
        that.openModal({title: 'Establishments', maxHeight: 500});
      });
      $req.fail(function(){
        that.flashError('We had an error getting establishments');
      })
    });
  },

  initShowEstablishment: function(){
    var that = this;
    $('body').on('click', '.js-show-establishment', function(e){
      e.preventDefault();
      var id   =  $(this).attr('id');
      var $req = $.get('/establishments/' + id);
      $req.done(function(data){
        var establishment = $.parseJSON(data)
        that.bounds = new google.maps.LatLngBounds();
        that.clearMarkers();
        that.closeModal();
        that.placeMarkers([establishment]);
        for (i = 0, markers = that.markers; i < markers.length; i++) {
          that.addInfoWindow(markers[i], function(marker){
            that.addListToInfoWindow(establishment.beers, marker);
          });
        }
      });
      $req.fail(function(){
        that.flashError('We had an error showing this establishment');
      })
    });
  },

  initSuggestions: function(){
    var that = this;
    $('body').on('click', '#js-suggest', function(e){
      e.preventDefault();
      var $req = $.get('/suggestions/new');
      $req.then(function(data){
        that.setModalContent(data);
      });
      $req.done(function(){
        that.openModal({title: 'New Suggestion'});
      });
      $req.fail(function(){
        that.flashError('An error occurred');
      });
    });
  },

  initSuggestionsForm: function(){
    var that = this;
    $('body').on('submit', '#new-suggestion', function(e){
      e.preventDefault();
      var data = $(this).serialize();
      if (that.validateSuggestionForm(this)){
        $req = $.post('/suggestions', data);
        $req.then(function(){
          that.closeModal();
        });
        $req.done(function(){
          that.flashSuccess('Thank you for your suggestion!');
        });
        $req.fail(function(){
          that.flashError('We had an error processing your suggestion');
        });
      }
    });
  },

  initWhatIsBeermapper: function(){
    $('body').on('click', '#js-what-is-beermapper', function(e){
      e.preventDefault();
      var $li     = $(e.target).closest('li');
      var $whatIs = $('.whatis-beermapper');
      if ($whatIs.is(':visible')) {
        $li.removeClass('active');
        $whatIs.slideUp(200);
      } else {
        $li.addClass('active');
        $whatIs.slideDown(200);
      }
    });
  },

  validateSuggestionForm: function(form){
    var $name  = $(form).find('input#suggestion-name');
    var $url   = $(form).find('input#suggestion-url');
    var inputs = [$name, $url];
    var valid  = true
    for (var i = 0; i < inputs.length; i++){
      var $input = inputs[i];
      var inputValue = $input.val();
      var $formGroup = $input.closest('.form-group');
      if (!inputValue.length){
        $formGroup.addClass('has-error');
        valid = false
      } else {
        $formGroup.removeClass('has-error');
      }
    }
    return valid
  },

  setModalContent: function(content){
    $('.modal').html(content);
  },

  openModal: function(options){
    var defaults = { modal: true, width: 400, height: 'auto' }
    var settings = $.extend(defaults, options);
    $('.modal').dialog(settings);
  },

  closeModal: function(){
    $('.modal').dialog('close');
  },

  getDirections: function(start, end){
    var that = this;
    var mode = $('#travel-mode').val();
    var request = {
      origin:      $('input#start').val(),
      destination: $('input#end').val(),
      travelMode: google.maps.TravelMode[mode]
    };

    this.infowindow.close();
    this.closeModal();
    that.directionsService.route(request, function(result, status){
      if (status == google.maps.DirectionsStatus.OK){
        that.directionsDisplay.setMap(that.map);
        that.directionsDisplay.setDirections(result);
      } else {
        that.flashError('Directions request failed');
      }
    });
  },

  clearDirections: function(){
    this.directionsDisplay.setMap(null);
  },

  setMap: function(){
    var map     = document.getElementById("map");
    var that    = this;
    var coords  = $(map).data('center');
    var options = {
      zoom: 11,
      center: new google.maps.LatLng(coords[0], coords[1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    that.map = new google.maps.Map(map, options);
  },

  sendRequest: function(beer){
    var that = this;

    var $req = $.ajax({
      type: 'POST',
      dataType: 'script',
      data: { 'beer' : beer },
      url: '/search',
      beforeSend: function(){
        return that.clearMarkers()
      }
    });

    $req.done(function(data){
      that.clearDirections();
      that.bounds = new google.maps.LatLngBounds();
      var establishments = $.parseJSON(data);
      if (establishments.length){
        that.placeMarkers(establishments);
        for (var i = 0, markers = that.markers; i < markers.length; i++) {
          that.addInfoWindow(markers[i], that.getBeerMatches);
        }
      } else {
        that.flashError('No Results');
      }
    });

    $req.fail(function(){
      that.flashError('Request failed');
    });
  },

  clearMarkers: function(){
    for (var i = 0; i < this.markers.length; i++) {
      this.markers[i].setMap(null);
    }
    this.markers = [];
  },

  placeMarkers: function(establishments){
    for (i = 0; i < establishments.length; i++) {
      this.addMarker(establishments[i]);
    }
    this.map.fitBounds(this.bounds);
  },

  // Add a marker to the map and push to the array.
  addMarker: function (establishment) {
    var latLng = this.latLngFromEstablishment(establishment);
    var marker = new google.maps.Marker({
      position:  latLng,
      animation: google.maps.Animation.DROP,
      map:       this.map,
      name:      establishment.name,
      id:        establishment.id
    });
    this.registerMarker(marker, latLng);
  },

  latLngFromEstablishment: function(establishment){
    var lat = establishment.latLng[0];
    var lng = establishment.latLng[1];

    return new google.maps.LatLng(lat, lng);
  },

  registerMarker: function(marker, latLng){
    this.markers.push(marker);
    this.bounds.extend(latLng);
  },

  makeBeerList: function(beers){
    var list = ''
    for (i = 0; i < beers.length; i++) {
      var beer = beers[i]['name']
      list += '<li>' + beer + '</li>'
    }
    return list;
  },

  getBeerMatches: function(marker){
    var that = this;
    var beer = $('input#beer').val();
    var $req = $.get('/beers', { beer: beer, establishment: marker.id });

    $req.done(function(data){
      var beers = $.parseJSON(data);
      that.addListToInfoWindow(beers, marker)
    });
  },

  addListToInfoWindow: function(beers, marker){
    var that    = this;
    var list    = that.makeBeerList(beers);
    var content = that.markerHTML(marker, list);
    that.infowindow.setContent(content);
    that.infowindow.open(that.map, marker);
  },

  addInfoWindow: function(marker, clickCallback){
    var that = this
    google.maps.event.addListener(marker, 'click', (function(marker) {
      return function() {
        clickCallback.call(that, marker)
      }
    })(marker));
  },

  markerHTML: function(marker, list){
    return '<div class="establishment-info-window">\
              <a href="#" class="js-get-directions" data-position="' + marker.position + '">' + marker.name + '</a>\
              <ul id="beer-matches-' + marker.id + '">' + list + '</ul>\
            </div>'
  },

  flashSuccess: function(msg){
    this.flash('ot-notice', msg);
  },

  flashError: function(msg){
    this.flash('ot-alert', msg);
  },

  flash: function(type, msg){
    $('.flash-messages').html("<div class='flash " + type + "'>" + msg + "</div>");
    setTimeout(function(){
      $('.flash').fadeOut('fast')
    }, 3000);
  }
}

$(function(){
  onTap.init();
});
