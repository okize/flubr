const fs = require('fs');
const path = require('path');

// returns parsed package.json
module.exports = (parsed) => {
  const pak = fs.readFileSync(path.join(__dirname, '..', '..', 'package.json'), 'utf8');
  if (parsed) { return JSON.parse(pak); }
  return pak;
};
