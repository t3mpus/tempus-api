request = require 'request'
should = require 'should'

startApp = require './../start_app'
base = require './../base'
options = require './../options'
UserTestHelper = require './user_test_helper'

describe 'Users', ->
  before (done) ->
    startApp -> UserTestHelper.addUsers done

  it 'Get all Users', (done)->
    request (base '/users'), options, (e,r,b)->
      r.statusCode.should.be.equal 200
      b.should.have.property 'users'
      b.users.should.have.property 'length', UserTestHelper.users.length
      UserTestHelper.isEqual b.users
      done()
