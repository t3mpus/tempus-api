BaseController = require "#{__dirname}/base"
Project = require "#{__dirname}/../models/project"
sql = require 'sql'
async = require 'async'

TimeEntriesController = require "#{__dirname}/time_entries"

class ProjectsController extends BaseController
  project: sql.define
    name: 'projects'
    columns: (new Project).columns()

  usersprojects: sql.define
    name: 'users_projects'
    columns: ['userId', 'projectId']

  getAll: (callback)->
    statement = @project.select(@project.star()).from(@project)
    @query statement, callback

  getProjectsForUser: (userId, callback) ->
    statement = @project
                .select @project.star(), @usersprojects.star()
                .where(@usersprojects.userId.equals userId)
                .from(
                  @project
                    .join @usersprojects
                    .on @project.id.equals @usersprojects.projectId
                )
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
    userId = spec.userId
    if not userId
      return callback new Error 'UserId is required'
    t = @transaction()
    start = =>
      statementNewProject = (@project.insert spec.requiredObject()).returning '*'
      t.query statementNewProject, (results) =>
        project = new Project results?.rows[0]
        statementNewUsersProject = (@usersprojects.insert {userId:userId, projectId: project.id})
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
    {time_entry} = TimeEntriesController
    deleteProjectTimeEntries = time_entry.delete().where(time_entry.projectId.equals(key))
    deleteProject = @project.delete().where(@project.id.equals(key))
    deleteUsersProjectsRows = @usersprojects.delete().where(@usersprojects.projectId.equals key)
    t = @transaction()
    start = ->
      async.eachSeries [deleteProjectTimeEntries, deleteUsersProjectsRows, deleteProject],
        (s, cb)->
          t.query s, ()->
            cb()
        , ->
          t.commit()

    t.on 'begin', start
    t.on 'error', callback
    t.on 'commit', ->
      callback()
    t.on 'rollback', ->
      callback new Error "Could not delete project with id #{key}"

  exists: (key, callback) ->
    findProject = @project.select(@project.id).where(@project.id.equals(key)).limit(1)
    @query findProject, (err, rows) ->
      if err or rows.length isnt 1
        callback new Error "#{key} not found"
      else
        callback null, yes


module.exports = ProjectsController.get()
