import Ember from 'ember';
import ResetScroll from '../mixins/reset-scroll';

const EstablishmentRoute = Ember.Route.extend(ResetScroll, {
  model(params) {
    return this.store.find('establishment', params.id);
  }
});

export default EstablishmentRoute;
