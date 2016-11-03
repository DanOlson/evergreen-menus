import Ember from 'ember';

export default Ember.Component.extend({
  establishments: [],

  didReceiveAttrs() {
    this._super(...arguments);
    // console.log(`beer-search: didReceiveAttrs() ${...arguments}`);
    // this.get('establishments').then((establishments) => {
    //   this.set('establishments', establishments);
    // });
  }
});
