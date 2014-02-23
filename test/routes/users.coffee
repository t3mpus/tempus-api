request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
options = require './../options'
UserTestHelper = require './user_test_helper'

testUsers = []

makeUser = (testUserEmail, status, cb)->
  ops = options()
  ops.body =
    firstName: 'Test'
    lastName: 'User'
    email: testUserEmail
    password: 'keyboard cats'
  request.post (base '/users'), ops, (e,r,b)->
    r.statusCode.should.be.equal status
    UserTestHelper.validate b if r.statusCode is 200
    testUsers.push b if r.statusCode is 200
    cb(b)

describe 'Users', ->
  before (done) ->
    startApp -> done()

  after (done) ->
    async.each testUsers, (u, cb)->
      request.del (base "/users/#{u.id}"), options(u), (e,r,b)->
        r.statusCode.should.be.equal 200
        cb()
    , done

  it.skip 'Get all Users', (done)->
    #Will require an Admin account
    request (base '/users'), options(), (e,r,b)->
      r.statusCode.should.be.equal 200
      should.equal UserTestHelper.users.length <= b.length, yes
      _.each b, UserTestHelper.validate
      done()

  it 'Creates a new user', (done) ->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, (b)->
      UserTestHelper.validate b
      b.should.have.property 'credentials'
      b.credentials.should.have.property 'secret'
      done()

  it.skip 'can get each user individually', (done)->
    request (base '/users'), options(), (e,r,b)->
      iterator = (u, cb)->
        request (base "/users/#{u.id}"), options(u), (e,r,b)->
          r.statusCode.should.be.equal 200
          UserTestHelper.validate b
          cb()

      async.eachLimit b, 100, iterator, done

  it 'cant have two users with the same email', (done)->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, -> makeUser t, 400, (error)->
      error.should.have.property 'error', 'user already exists'
      done()

  it 'can delete a user', (done)->
    t = "testUser#{uuid.v1()}@testuser.com"
    makeUser t, 200, (user)->
      request.del (base "/users/#{user.id}"), options(user), (e,r,b)->
        r.statusCode.should.be.equal 200
        request (base "/users/#{user.id}"), options(user), (e,r,b)->
          testUsers = _.without(testUsers, user)
          r.statusCode.should.be.equal 401
          done()

  it 'can handle a non existent user', (done)->
    request (base "/users/not-an-id"), options(), (e,r,b)->
      r.statusCode.should.be.equal 401
      done()

  it 'should not be able to access another', (done)->
    t = "t#{uuid.v1()}@testuser.com"
    b = "b#{uuid.v1()}@testuser.com"
    d = "d#{uuid.v1()}@testuser.com"
    async.map [b,t, d], (u, cb)->
      makeUser u, 200, (u)-> cb null, u
    , (err, users) ->
      differentUser = _.last(users)
      users = _.without(users, differentUser)
      async.eachSeries users, (e,cb)->
        request (base "/users/#{e.id}"), options(differentUser), (e,r,b)->
          r.statusCode.should.be.equal 401
          cb()
      , done

