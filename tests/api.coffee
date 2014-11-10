superagent = require 'superagent'
expect = require 'expect'
localhost = "http://localhost:#{process.env.PORT}"

describe 'rest api server', ->

  it 'retrieves a pass image url', (done) ->
    superagent.get("#{localhost}/api/images/random/pass").end (err, res) ->
      expect(err).toEqual null
      expect(res.statusCode).toEqual 200
      expect(typeof res.text).toEqual 'string'
      expect(res.text).toMatch /imgur.com/
      expect(res.text).toMatch /\.(jpeg|jpg|gif|png)$/
      done()

  it 'retrieves a fail image url', (done) ->
    superagent.get("#{localhost}/api/images/random/fail").end (err, res) ->
      expect(err).toEqual null
      expect(res.statusCode).toEqual 200
      expect(typeof res.text).toEqual 'string'
      expect(res.text).toMatch /imgur.com/
      expect(res.text).toMatch /\.(jpeg|jpg|gif|png)$/
      done()
