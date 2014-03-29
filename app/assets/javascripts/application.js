// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery
//= require handlebars
//= require ember
//= require ember-data
//= require_self
//= require beermapper
//= require ../../../vendor/assets/javascripts/bootstrap.min.js

// for more details see: http://emberjs.com/guides/application/
Beermapper = Ember.Application.create({
  LOG_TRANSITIONS: false,
  LOG_TRANSITIONS_INTERNAL: false,
  LOG_ACTIVE_GENERATION: false
});

Beermapper.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'api/v1'
});


//= require_tree .
