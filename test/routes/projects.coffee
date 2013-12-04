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
  p.should.have.property 'userid'
  p.should.have.property 'id'
  p.should.have.property 'createdDate'

testProjects = [ {name: 'p1'}, {name: 'p2'} ]

createTestUser = (cb)->
  ops = _.clone options
  ops.body =
    firstName: 'Test'
    lastName: 'ProjectUser'
    email: 'testProjectUser@testProjectUser.com'
    password: 'testing projects!'
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
        testProjects = _.map testProjects, (p, i)->
          p.name = "p#{i}"
          p.createdDate = new Date()
          p.userId = id
        async.each testProjects, createProject, done


  it 'should get all projects', (done)->
    request (base '/projects'), options, (e,r,b)->
      r.statusCode.should.be.equal 200
      b.should.have.property 'projects'
      _.each b.projects, validProject
      done()


