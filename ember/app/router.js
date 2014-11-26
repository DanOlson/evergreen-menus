import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType,

  didTransition: function(infos){
    this._super(infos);
    if(window.ga === undefined){ return; }

    Ember.run.next(function(){
      ga('send', 'pageview', window.location.hash.substring(1));
    });
  }
});

Router.map(function() {
  this.route('search');
  this.route('authenticated');
  this.resource('establishments', function(){
    this.route('new');
  });
  this.resource('establishment', { path: 'establishment/:id' });
  this.resource('establishment_suggestions', function(){
    this.route('new');
  });
  this.resource('sessions', function(){
    this.route('new');
  });
  this.resource('list_updates');
  this.resource('list_update', { path: '/list_updates/:id' });
});

export default Router;
