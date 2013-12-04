BaseController = require "#{__dirname}/base"
Project = require "#{__dirname}/../models/project"
sql = require 'sql'


class ProjectsController extends BaseController
  project: sql.define
    name: 'projects'
    columns: (new Project).columns()

  getAll: (callback)->
    statement = @project.select(@project.star()).from(@project)
    @query statement, callback

  getOne: (key, callback)->

  create: (spec, callback)->

module.exports = ProjectsController.get()
