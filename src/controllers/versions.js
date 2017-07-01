const path = require('path');
const request = require('request');
const pak = require(path.join('..', '..', 'package.json'));

module.exports = {

  getLocalVersion(req, res) {
    return res.send(pak.version);
  },

  getRemoteVersion(req, res) {
    const GITHUB_PAK_URL = 'https://raw.githubusercontent.com/okize/flubr/master/package.json';
    return request(GITHUB_PAK_URL, function(error, response, body) {
      if (!error && (response.statusCode === 200)) {
        return res.send(JSON.parse(body).version);
      } else {
        console.error(error);
        return res.send(null);
      }
    });
  }
};
