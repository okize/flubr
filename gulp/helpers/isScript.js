const path = require('path');

// allow only .js files to prevent
// accidental inclusion of other file types
module.exports = name => /(\.(js)$)/i.test(path.extname(name));
