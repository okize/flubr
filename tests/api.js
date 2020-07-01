const superagent = require('superagent');
const expect = require('expect');
const mocha = require('mocha');

const { describe, it } = mocha;
const server = `http://localhost:${process.env.PORT}`;

superagent.get(server).catch((error) => {
  if (error) {
    if (error.status === 503) {
      console.error(`SERVICE UNAVAILABLE! \n\nFor tests to run an app server must be available at \`${server}\`\n`);
    } else {
      console.error(error);
    }
    process.exit(1);
  }
});

describe('rest api server', () => {
  it('retrieves a pass image url', () => {
    superagent.get(`${server}/api/images/random/pass`).then((err, res) => {
      expect(err).toEqual(null);
      expect(res.statusCode).toEqual(200);
      expect(typeof res.text).toEqual('string');
      expect(res.text).toMatch(/imgur.com/);
      expect(res.text).toMatch(/\.(jpeg|jpg|gif|png)$/);
    }).catch((err) => {
      // console.error(err);
    });
  });

  it('retrieves a fail image url', () => {
    superagent.get(`${server}/api/images/random/fail`).then((err, res) => {
      expect(err).toEqual(null);
      expect(res.statusCode).toEqual(200);
      expect(typeof res.text).toEqual('string');
      expect(res.text).toMatch(/imgur.com/);
      expect(res.text).toMatch(/\.(jpeg|jpg|gif|png)$/);
    }).catch((err) => {
      // console.error(err);
    });
  });
});
