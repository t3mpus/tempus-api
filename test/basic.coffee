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


