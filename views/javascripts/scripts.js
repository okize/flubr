import attachFastClick from 'fastclick';

import keyboard from './keyboard';
import homepage from './homepage';
import application from './application';

homepage();
keyboard();
application();

// add fastclick to remove click delay on touch devices
attachFastClick(document.body);
