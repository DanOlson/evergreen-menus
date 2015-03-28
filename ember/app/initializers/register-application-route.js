import ApplicationRoute from '../routes/application'

export default {
  name: 'register-application-route',
  initialize: function(container) {
    container.register('route:application', ApplicationRoute, { singleton: true });
  }
};
