// For more information see: http://emberjs.com/guides/routing/

Beermapper.Router.map(function() {
  this.route('search');
  this.resource('establishment', { path: 'establishment/:id' });
  this.resource('establishment_suggestions', function(){
    this.route('new');
  });
});
