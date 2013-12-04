BaseController = require "#{__dirname}/base"
ProjectModel = require "#{__dirname}/../models/project"

class ProjectsController extends BaseController
  getAll: (callback)->

  getOne: (key, callback)->

  create: (spec, callback)->

module.exports = ProjectsController.get()
