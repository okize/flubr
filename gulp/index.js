// this file boostraps all the gulp tasks

// load env vars here so they'll be available to all gulp tasks
require('dotenv').load();

// ensure that env variables required for the application to run have been set
require('dotenv-assert')();

const config = require('./config');
const tasks = require('./helpers/getTaskList');

// load all the gulp task modules
tasks().forEach(task => require(`${config.taskDir}${task}`));
