Beermapper.MapUtils = Ember.Mixin.create({
  mapOptions: function(){
    return {
      zoom: 11,
      center: new google.maps.LatLng(this.get('latitude'), this.get('longitude')),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
  },

  map: function(el){
    return new google.maps.Map(el, this.mapOptions());
  }
});
