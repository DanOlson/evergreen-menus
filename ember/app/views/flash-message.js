import Ember from 'ember';

var FlashMessageView = Ember.View.extend({
  classNames: ['flash-message'],
  classNameBindings: ['isAlert', 'isWarning', 'isNotice', 'isInfo'],
  isAlertBinding: 'context.isAlert',
  isWarningBinding: 'context.isWarning',
  isNoticeBinding: 'context.isNotice',
  isInfoBinding: 'context.isInfo',
  templateName: 'flash-message',
  actions: {
    close: function(){
      this.$().fadeOut(300);
    }
  }
});

export default FlashMessageView;
