export default {
  name: "inject-application-route",
  before: "register-application-route",

  initialize: function(container, application) {
    application.inject('controller', 'applicationRoute', 'route:application');
  }
};
