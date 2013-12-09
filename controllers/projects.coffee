BaseController = require "#{__dirname}/base"
Project = require "#{__dirname}/../models/project"
sql = require 'sql'
async = require 'async'

class ProjectsController extends BaseController
  project: sql.define
    name: 'projects'
    columns: (new Project).columns()

  usersprojects: sql.define
    name: 'usersprojects'
    columns: ['userid', 'projectid']

  getAll: (callback)->
    statement = @project.select(@project.star()).from(@project)
    @query statement, callback

  getOne: (key, callback)->
    statement = @project.select(@project.star()).from(@project)
      .where(@project.id.equals key)
    @query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new Project rows[0]

  create: (spec, callback)->
    userid = spec.userId
    if not userid
      return callback new Error 'UserId is required'
    t = @transaction()
    start = =>
      statementNewProject = (@project.insert spec.requiredObject()).returning '*'
      t.query statementNewProject, (results) =>
        project = new Project results?.rows[0]
        statementNewUsersProject = (@usersprojects.insert {userid:userid, projectid: project.id})
        t.query statementNewUsersProject, ()->
          t.commit project

    t.on 'begin', start
    t.on 'error', (err)->
      callback err
    t.on 'commit', (project)->
      callback null, project
    t.on 'rollback', ->
      callback new Error "Couldn't create new project"


  deleteOne: (key, callback)->
    deleteProject = @project.delete().where(@project.id.equals(key))
    deleteUsersProjectsRows = @usersprojects.delete().where(@usersprojects.projectid.equals key)
    t = @transaction()
    start = ->
      async.eachSeries [deleteUsersProjectsRows, deleteProject],
        (s, cb)->
          t.query s, ()->
            cb()
        , ->
          t.commit()

    t.on 'begin', start
    t.on 'error', console.log
    t.on 'commit', ->
      callback()
    t.on 'rollback', ->
      callback new Error "Could not delete project with id #{key}"


module.exports = ProjectsController.get()
