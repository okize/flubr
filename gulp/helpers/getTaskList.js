const fs = require('fs');
const config = require('../config');
const isScript = require('../helpers/isScript');

// returns a filtered list of all the scripts in tasks dir (js & coffee only)
module.exports = () => fs.readdirSync(config.taskDir).filter(isScript);
