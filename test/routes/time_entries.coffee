request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
options = require './../options'

TimeEntry = require "#{__dirname}/../../models/time_entry"

testUser = undefined
testProject = undefined

makeUser = (cb)->
  ops = _.clone options
  ops.body =
    firstName: 'Test'
    lastName: 'User'
    email: uuid.v1() + 'super-awesome-email@email.com'
    password: 'keyboard cats'
  request.post (base '/users'), ops, (e,r,b)->
    cb b

makeProject = (userId, cb)->
  ops = _.clone options
  ops.body =
    name: 'test project'
    createdDate: new Date()
    userId: userId
  request.post (base '/projects'), ops, (e,r,b)->
    cb b

describe 'Time Entries', ->
  before (done) ->
    startApp ->
      makeUser (user)->
        testUser = user
        makeProject user.id, (project)->
          testProject = project
          done()

  after (done) ->
    deleteUserAndProject = (cb)->
      async.eachSeries [
        {what: 'projects', id:testProject.id}
        {what: 'users', id:testUser.id}
      ], (obj)->
        request.del (base "/#{obj.what}/#{obj.id}"), _.clone(options), (e,r,b)->
          cb(e)
    deleteUserAndProject done

  it 'should make a time entry', (done)->
    ops = _.clone options
    ops.body =
      start: new Date('May 4 1987')
      end: new Date()
      message: 'I am a wonderful time entry :)'
      projectId: testProject.id
      userId: testUser.id
    teb = new TimeEntry ops.body
    teb.validate().should.be.true
    request.post (base '/time_entries'), ops, (e,r,b)->
      r.statusCode.should.be.equal 200
      te = new TimeEntry b
      te.validate().should.be.true
      done()
