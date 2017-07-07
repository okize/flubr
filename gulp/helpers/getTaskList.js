// returns a filtered list of all the scripts in tasks dir (js & coffee only)

const fs = require('fs');
const config = require('../config');
const isScript = require('../helpers/isScript');

module.exports = () => fs.readdirSync(config.taskDir).filter(isScript);
