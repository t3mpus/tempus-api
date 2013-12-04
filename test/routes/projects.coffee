request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
options = require './../options'

describe 'Projects', ->
  before (done) ->
    startApp -> done()

  it 'should get all projects', (done)->
    request (base '/projects'), options, (e,r,b)->
      r.statusCode.should.be.equal 200
      b.should.have.property 'projects'
      done()


