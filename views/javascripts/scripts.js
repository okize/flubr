// add fastclick to remove click delay on touch devices
import attachFastClick from 'fastclick';
attachFastClick(document.body);

// load keyboard bindings
require('./keyboard')();

// load homepage and main app scripts
require('./homepage')();
require('./application')();
