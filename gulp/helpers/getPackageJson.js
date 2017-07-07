// returns parsed package.json

const fs = require('fs');
const path = require('path');

module.exports = function (parsed) {
  const pak = fs.readFileSync(path.join(__dirname, '..', '..', 'package.json'), 'utf8');
  if (parsed) { return JSON.parse(pak); } return pak;
};
