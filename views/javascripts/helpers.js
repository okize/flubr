// jquery has to be assigned to window for velocity to work (as of 0.5.1)
const $ = (window.jQuery = (window.$ = require('jquery')));
const velocity = require('velocity-animate');
const velocityui = require('velocity-animate/velocity.ui');
const moment = require('moment');

export default {

  animate($el, type, cb) {
    switch (type) {
      case 'pop': return $el.velocity('callout.pulse', 350, cb);
      case 'delete': return $el.velocity('transition.flipBounceYOut', 500, cb);
      case 'addRow': return $el.velocity('transition.slideDownIn', 500, cb);
      case 'deleteRow': return $el.velocity('transition.slideDownOut', 500, cb);
    }
  },

  formatTime(date) {
    return moment(date).format('lll');
  },
};
