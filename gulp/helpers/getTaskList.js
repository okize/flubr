const fs = require('fs');
const config = require('../config');
const isScript = require('./isScript');

// returns a filtered list of all the scripts in tasks dir
module.exports = () => fs.readdirSync(config.taskDir).filter(isScript);
