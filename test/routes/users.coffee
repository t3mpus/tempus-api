request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
options = require './../options'
UserTestHelper = require './user_test_helper'

makeUser = (testUserEmail, status, cb)->
  ops = _.clone options
  ops.body =
    firstName: 'Test'
    lastName: 'User'
    email: testUserEmail
    password: 'keyboard cats'
  request.post (base '/users'), ops, (e,r,b)->
    r.statusCode.should.be.equal status
    UserTestHelper.validate b if r.statusCode is 200
    cb(b)

describe 'Users', ->
  before (done) ->
    startApp -> done()

  after (done) ->
    request (base '/users'), _.clone(options), (e,r,b)->
      testUsers = _.filter b, (u)->
        return u.firstName is 'Test' and u.lastName is 'User'
      async.each testUsers, (u, cb)->
        request.del (base "/users/#{u.id}"), _.clone(options), cb
      , done

  it 'Get all Users', (done)->
    request (base '/users'), _.clone(options), (e,r,b)->
      r.statusCode.should.be.equal 200
      should.equal UserTestHelper.users.length <= b.length, yes
      _.each b, UserTestHelper.validate
      done()

  it 'Creates a new user', (done) ->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, (b)->
      UserTestHelper.validate b
      done()

  it 'can get each user individually', (done)->
    request (base '/users'), _.clone(options), (e,r,b)->
      iterator = (id, cb)->
        request (base "/users/#{id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 200
          UserTestHelper.validate b
          cb()

      async.eachLimit _.map(b, (u)-> u.id), 100, iterator, done

  it 'cant have two users with the same email', (done)->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, -> makeUser t, 400, (error)->
      error.should.have.property 'error', 'user already exists'
      done()

  it 'can delete a user', (done)->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, (user)->
      request.del (base "/users/#{user.id}"), _.clone(options), (e,r,b)->
        r.statusCode.should.be.equal 200
        request (base "/users/#{user.id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 404
          done()

  it 'can handle a non existent user', (done)->
    request (base "/users/not-an-id"), _.clone(options), (e,r,b)->
      r.statusCode.should.be.equal 404
      done()
