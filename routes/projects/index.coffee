ProjectsController = require "#{__dirname}/../../controllers/projects"
TimeEntriesController = require "#{__dirname}/../../controllers/time_entries"

Project = require "#{__dirname}/../../models/project"
_ = require 'underscore'

handler = (app) ->

  app.get '/projects', (req, res) ->
    ProjectsController.getProjectsForUser req.user.id, (err, projects) ->
      if err
        res.send 400, error: 'Error'
      else
        res.send _.map projects, (p) -> (new Project p).publicObject()

  app.post '/projects', (req, res) ->
    project = new Project req.body
    project.userId = req.user.id
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
        TimeEntriesController.deleteForProject req.params.id, (err)->
          if err
            res.send 400, error: "Couldn't delete time entries"
          else
            res.send 200

  app.get '/projects/:id/time_entries', (req, res) ->
    projectId = req.params.id
    ProjectsController.exists projectId, (err, exists) ->
      if err
        res.send 404, error: "Project #{projectId} not found"
      else
        TimeEntriesController.getForProject projectId, (err, time_entries) ->
          if err
            res.send 400, error: 'Error'
          else
            res.send time_entries


module.exports = handler
