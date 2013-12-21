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
timeEntriesCreated = []

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
    deleteTimeEntries = (cb)->
      async.each timeEntriesCreated, (e, cb)->
        request.del (base "/time_entries/#{e.id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 200
          cb e
      , cb
    async.parallel [deleteTimeEntries, deleteUserAndProject], done

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
      timeEntriesCreated.push te
      te.validate().should.be.true
      done()

  it 'should get a time entry', (done)->
    ops = _.clone options
    ops.body =
      start: new Date('January 1 1994')
      end: new Date()
      message: 'Try and get me!!!'
      projectId: testProject.id
      userId: testUser.id
    teb = new TimeEntry ops.body
    teb.validate().should.be.true
    request.post (base '/time_entries'), ops, (e,r,b)->
      r.statusCode.should.be.equal 200
      te = new TimeEntry b
      timeEntriesCreated.push te
      te.validate().should.be.true
      request (base "/time_entries/#{te.id}"), _.clone(options), (e,r,b)->
        r.statusCode.should.be.equal 200
        tegb = new TimeEntry b
        tegb.validate().should.be.true
        done()

  it 'should delete a time entry', (done)->
    ops = _.clone options
    ops.body =
      start: new Date('June 18, 2013')
      end: new Date('June 22, 2013')
      message: 'I will be deleted very soon!'
      projectId: testProject.id
      userId: testUser.id
    teb = new TimeEntry ops.body
    teb.validate().should.be.true
    request.post (base '/time_entries'), ops, (e,r,b)->
      teb = new TimeEntry b
      r.statusCode.should.be.equal 200
      request.del (base "/time_entries/#{teb.id}"), _.clone(options), (e,r,b)->
        r.statusCode.should.be.equal 200
        request (base "/time_entries/#{teb.id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 404
          done()

  describe 'in a project', ->
    it 'should have time entries associated with the project', (done)->
      request.get (base "/projects/#{testProject.id}/time_entries"), _.clone(options), (e,r,b)->
        r.statusCode.should.be.equal 200
        b.should.have.property 'length'
        if b.length is 0
          throw new Error 'No time_entries to test'
        else
          _.every b, (t)-> (new TimeEntry t).validate().should.be.true
          done()

    it 'should have an appropriate error with a bad project id', (done)->
      request.get (base "/projects/999933/time_entries"), _.clone(options), (e,r,b) ->
        r.statusCode.should.be.equal 404
        b.error.should.not.be.equal null
        done()

    it 'should delete time entries if project is deleted', (done) ->
      makeProject testUser.id, (p) ->
        makeTimeEntry = (seed, cb)->
          ops = _.clone options
          ops.body =
            start: new Date()
            end: new Date()
            message: 'I will be deleted very soon!' + seed
            projectId: p.id
            userId: testUser.id

          request.post (base "/time_entries"), ops, (e,r,b)->
            cb null, b

        makeEntries = (num, cb)->
          async.map [1..num], makeTimeEntry, (err, entries)->
            entries.length.should.be.equal num
            cb()

        checkEntries = (num, cb) ->
          request.get (base "/projects/#{p.id}/time_entries"), _.clone(options), (e,r,b)->
            r.statusCode.should.be.equal 200
            b.length.should.equal num
            cb()

        deleteProject = (project, cb)->
          request.del (base "/projects/#{p.id}"), _.clone(options), (e,r,b)->
            r.statusCode.should.be.equal 200
            cb()

        desiredEntries = 10
        makeEntries desiredEntries, ()->
          checkEntries desiredEntries, ()->
            deleteProject p, ()->
              checkEntries 0, done

