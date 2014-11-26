import Ember from 'ember';
import ResetScroll from '../mixins/reset-scroll';

var EstablishmentRoute = Ember.Route.extend(ResetScroll, {
  model: function(params){
    return this.store.find('establishment', params.id);
  }
});

export default EstablishmentRoute;
