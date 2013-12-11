should = require 'should'
riak = require "#{__dirname}/../../db/riak"

describe 'app riak object', ->
  it 'should have a function getClient', ->
    riak.should.have.property 'getClient'
    riak.getClient.should.be.type 'function'

  it 'should respond to pings', (done)->
    @timeout 1000
    client = riak.getClient()
    client.ping (err, result)->
      throw err if err
      result.should.be.equal yes
      done()


