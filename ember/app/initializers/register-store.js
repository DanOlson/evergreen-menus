import DS from 'ember-data';
export default {
  name: 'register-store',
  initialize: function(container, application){
    container.register('store:main', DS.Store, { singleton: true });
  }
};
