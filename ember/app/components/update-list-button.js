import Ember from 'ember';

export default Ember.Component.extend({
  attributeBindings: ['isUpdating:disabled'],
  isUpdating: false,

  actions: {
    updateList() {
      const { establishment } = this.attrs;
      this.set('isUpdating', true);
      this.attrs.onClick(establishment).then(() => {
        this.set('isUpdating', false);
      }).catch(() => {
        this.set('isUpdating', false);
      });
    }
  }
});
