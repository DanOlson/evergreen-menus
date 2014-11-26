import DS from 'ember-data';

var User = DS.Model.extend({
  firstName: DS.attr(),
  lastName: DS.attr(),
  username: DS.attr(),

  name: function(){
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});

export default User;
