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
      if err or not project.validate()
        res.send 404, error: 'Error'
      else
        res.send project.publicObject()

  app.delete '/projects/:id', (req, res) ->
    ProjectsController.deleteOne req.params.id, (err) ->
      if err
        res.send 404, error: "Project with id #{req.params.id} not found"
      else
        res.send 200


module.exports = handler
