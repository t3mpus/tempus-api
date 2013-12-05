BaseController = require "#{__dirname}/base"
Project = require "#{__dirname}/../models/project"
sql = require 'sql'


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
    statement = (@project.insert spec.requiredObject()).returning '*'
    @query statement, (err, rows)=>
      if err
        return callback err
      else
        project = new Project rows[0]
        statement = (@usersprojects.insert {userid:userid, projectid: project.id})
        @query statement, (err)->
          if err
            return callback err
          else
            return callback null, project

module.exports = ProjectsController.get()
