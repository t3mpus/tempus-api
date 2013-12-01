request = require 'request'
should = require 'should'
_ = require 'underscore'

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
      should.equal UserTestHelper.users.length <= b.users.length, yes
      done()

  it 'Creates a new user', (done) ->
    ops = _.clone options
    ops.body =
      firstName: 'Will'
      lastName: 'Laurance'
      email: 'w.laurance@gmail.com'
      password: 'keyboard cats'
    request.post (base '/users'), ops, (e,r,b)->
      r.statusCode.should.be.equal 200
      UserTestHelper.validate b
      done()
