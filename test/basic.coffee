request = require 'request'
should = require 'should'

startApp = require './start_app'
base = require './base'
options = require './options'

describe 'Basic Things', ->
  before (done) ->
    startApp done

  it 'should return version information', (done)->
    request (base '/'), options, (e,r,b)->
      r.statusCode.should.be.equal 200
      b.should.have.property 'version', require('../package').version
      done()

  it 'should send a JSON response on 404', (done)->
    request (base '/' + 'not-an-existent-route1234', no), options, (e,r,b)->
      r.statusCode.should.be.equal 404
      r.headers['content-type'].should.startWith 'application/json'
      b.error.should.be.equal '/not-an-existent-route1234 was not found'
      done()


