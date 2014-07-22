superagent = require 'superagent'
expect = require 'expect'
describe 'rest api server', ->

  it 'retrieves a pass image url', (done) ->
    superagent.get('http://localhost:3333/api/images/random/pass').end (err, res) ->
      expect(err).toEqual null
      expect(res.statusCode).toEqual 200
      expect(typeof res.text).toEqual 'string'
      expect(res.text).toMatch /imgur.com/
      expect(res.text).toMatch /\.(jpeg|jpg|gif|png)$/
      done()

  it 'retrieves a fail image url', (done) ->
    superagent.get('http://localhost:3333/api/images/random/fail').end (err, res) ->
      expect(err).toEqual null
      expect(res.statusCode).toEqual 200
      expect(typeof res.text).toEqual 'string'
      expect(res.text).toMatch /imgur.com/
      expect(res.text).toMatch /\.(jpeg|jpg|gif|png)$/
      done()
