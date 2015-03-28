export default {
  name: "inject-store",
  before: "register-store",

  initialize: function(container, application) {
    application.inject('controller', 'store', 'store:main');
    application.inject('route', 'store', 'store:main');
  }
};
