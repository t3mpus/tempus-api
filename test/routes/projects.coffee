request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
options = require './../options'

validProject = (p)->
  p.should.have.property 'name'
  p.should.have.property 'id'
  p.should.have.property 'createdDate'

testProjects = [ {name: 'p1'}, {name: 'p2'} ]

testUserId = undefined

createTestUser = (cb)->
  ops = _.clone options
  ops.body =
    firstName: 'Test'
    lastName: 'ProjectUser'
    email: "testProjectUser#{uuid.v1()}@testProjectUser.com"
    password: 'testing projects!'
  testUser = ops.body
  request.post (base '/users'), ops, (e,r,b)->
    cb null, b.id

createProject = (project, callback)->
  ops = _.clone options
  ops.body = project
  request.post (base '/projects'), ops, (e,r,b)->
    r.statusCode.should.be.equal 200
    validProject b
    callback()

describe 'Projects', ->
  before (done) ->
    startApp ->
      createTestUser (e, id)->
        testUserId = id
        testProjects = _.map testProjects, (p)->
          p.createdDate = new Date()
          p.userId = id
          return p
        async.each testProjects, createProject, done

  after (done) ->
    ops = _.clone options
    request.del (base "/users/#{testUserId}"), ops, (e,r,b)->
      r.statusCode.should.be.equal 200
      done()

  it 'should get all projects', (done)->
    request (base '/projects'), _.clone(options), (e,r,b)->
      r.statusCode.should.be.equal 200
      b.should.have.property 'projects'
      _.each b.projects, validProject
      done()

  it 'should get all projects individually', (done)->
    request (base '/projects'), _.clone(options), (e,r,b)->
      iterator = (p, cb)->
        request (base "/projects/#{p.id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 200
          validProject b
          cb()
      async.each b.projects, iterator, done


  it 'should fail when there is a bad user id', (done)->
    ops = _.clone options
    ops.body =
      createdDate: new Date()
      userId: 'not-valid'
      name: 'fake project'
    request.post (base '/projects'), ops, (e,rp,b)->
      request (base '/projects'), _.clone(options), (e,r,b)->
        found = no
        for project in b.projects
          if project.name is 'fake project'
            found = yes
            break
        found.should.be.equal no
        rp.statusCode.should.be.equal 400
        done()

  it 'should delete projects', (done)->
    ops = _.clone options
    ops.body =
      name: 'deleted-project'
      userId: testUserId
      createdDate: new Date()
    request.post (base '/projects'), ops, (e,r,b)->
      id = b.id
      validProject b
      request.del (base "/project/#{id}"), _.clone(options), (e,r,b)->
        r.statusCode.should.be.equal 200
        request (base "/project/#{id}"), _.clone(options), (e,r,b)->
          r.statusCode.should.be.equal 404
          done()


