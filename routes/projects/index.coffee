ProjectsController = require "#{__dirname}/../../controllers/projects"
Project = require "#{__dirname}/../../models/project"
_ = require 'underscore'

handler = (app) ->

  app.get '/projects', (req, res) ->
    ProjectsController.getAll (err, projects) ->
      if err
        res.send 400, error: 'Error'
      else
        res.send projects: _.map projects, (p) -> (new Project p).publicObject()

  app.post '/projects', (req, res) ->
    project = new Project req.body
    if project.validate()
      ProjectsController.create project, (err, project) ->
        if err
          res.send 400, error: 'Error'
        else
          res.send project.publicObject()
    else
      res.send 400, error: 'Error'

  app.get '/projects/:id', (req, res) ->
    ProjectsController.getOne req.params.id, (err, project)->
      if err
        res.send 404, error: 'Error'
      else
        res.send project.publicObject()


module.exports = handler
