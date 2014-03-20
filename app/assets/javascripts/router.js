Beermapper.Router.map(function() {
  this.route('search');
  this.resource('establishments');
  this.resource('establishment', { path: 'establishment/:id' });
  this.resource('establishment_suggestions', function(){
    this.route('new');
  });
});
