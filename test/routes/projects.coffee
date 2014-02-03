request = require 'request'
async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'

startApp = require './../start_app'
base = require './../base'
optionsBase = require './../options'
user_test_helper = require './user_test_helper'

validProject = (p)->
  p.should.have.property 'name'
  p.should.have.property 'id'
  p.should.have.property 'createdDate'

testProjects = [ {name: 'p1'}, {name: 'p2'} ]

testUser = undefined
projectsCreated = []

options = (u)->
  optionsBase u or testUser

createProject = (project, callback)->
  ops = options()
  ops.body = project
  request.post (base '/projects'), ops, (e,r,b)->
    r.statusCode.should.be.equal 200
    validProject b
    projectsCreated.push b
    callback()

deleteProject = (project, callback)->
  ops = options()
  request.del (base "/projects/#{project.id}"), ops, (e,r,b)->
    r.statusCode.should.be.equal 200
    callback()

describe 'Projects', ->
  before (done) ->
    startApp ->
      user_test_helper.makeUser (user)->
        testUser = user
        testProjects = _.map testProjects, (p)->
          p.createdDate = new Date()
          p.userId = user.id
          return p
        async.each testProjects, createProject, done

  after (done) ->
    async.each projectsCreated, deleteProject, ->
      ops = options()
      request.del (base "/users/#{testUser.id}"), ops, (e,r,b)->
        r.statusCode.should.be.equal 200
        done()

  it 'should get all projects', (done)->
    request (base '/projects'), options(), (e,r,b)->
      r.statusCode.should.be.equal 200
      _.each b, validProject
      done()

  it 'should get all projects individually', (done)->
    request (base '/projects'), options(), (e,r,b)->
      iterator = (p, cb)->
        request (base "/projects/#{p.id}"), options(), (e,r,b)->
          r.statusCode.should.be.equal 200
          validProject b
          cb()
      async.each b, iterator, done


  it 'should fail when there is a bad user id', (done)->
    ops = options()
    ops.body =
      createdDate: new Date()
      userId: 'not-valid'
      name: 'fake project'
    request.post (base '/projects'), ops, (e,rp,b)->
      request (base '/projects'), options(), (e,r,b)->
        found = no
        for project in b
          if project.name is 'fake project'
            found = yes
            break
        found.should.be.equal no
        rp.statusCode.should.be.equal 400
        done()

  it 'should delete projects', (done)->
    ops = options()
    ops.body =
      name: 'deleted-project'
      userId: testUser.id
      createdDate: new Date()
    request.post (base '/projects'), ops, (e,r,b)->
      r.statusCode.should.be.equal 200
      id = b.id
      validProject b
      request.del (base "/projects/#{id}"), options(), (e,r,b)->
        r.statusCode.should.be.equal 200
        request (base "/projects/#{id}"), options(), (e,r,b)->
          r.statusCode.should.be.equal 404
          done()


