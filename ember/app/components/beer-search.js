import Ember from 'ember';

const { isEmpty } = Ember;

export default Ember.Component.extend({
  didReceiveAttrs() {
    this._super();
    if (isEmpty(this.get('establishments'))) {
      this.attrs.onNoResults();
    }
  }
});
