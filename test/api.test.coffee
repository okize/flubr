superagent = require('superagent')
expect = require('expect.js')
describe 'express rest api server', ->

  id = undefined
  it 'post object', (done) ->
    superagent.post('http://localhost:3000/collections/test').send(
      name: 'John'
      email: 'john@rpjs.co'
    ).end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(res.body.length).to.eql 1
      expect(res.body[0]._id.length).to.eql 24
      id = res.body[0]._id
      done()
      return

    return

  it 'retrieves an object', (done) ->
    superagent.get('http://localhost:3000/collections/test/' + id).end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(typeof res.body).to.eql 'object'
      expect(res.body._id.length).to.eql 24
      expect(res.body._id).to.eql id
      done()
      return

    return

  it 'retrieves a collection', (done) ->
    superagent.get('http://localhost:3000/collections/test').end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(res.body.length).to.be.above 0
      expect(res.body.map((item) ->
        item._id
      )).to.contain id
      done()
      return

    return

  it 'updates an object', (done) ->
    superagent.put('http://localhost:3000/collections/test/' + id).send(
      name: 'Peter'
      email: 'peter@yahoo.com'
    ).end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(typeof res.body).to.eql 'object'
      expect(res.body.msg).to.eql 'success'
      done()
      return

    return

  it 'checks an updated object', (done) ->
    superagent.get('http://localhost:3000/collections/test/' + id).end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(typeof res.body).to.eql 'object'
      expect(res.body._id.length).to.eql 24
      expect(res.body._id).to.eql id
      expect(res.body.name).to.eql 'Peter'
      done()
      return

    return

  it 'removes an object', (done) ->
    superagent.del('http://localhost:3000/collections/test/' + id).end (e, res) ->

      # console.log(res.body)
      expect(e).to.eql null
      expect(typeof res.body).to.eql 'object'
      expect(res.body.msg).to.eql 'success'
      done()
      return

    return

  return
