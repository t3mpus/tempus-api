ProjectsController = require "#{__dirname}/../../controllers/projects"
ProjectModel = require "#{__dirname}/../../models/project"

handler = (app) ->

  app.get '/projects', (req, res) ->
    ProjectsController.getAll (err, projects) ->
      if err
        res.send 400, error: 'Error'
      else
        res.send projects:projects

  app.post '/projects', (req, res) ->
    ProjectsController.create req.body, (err, project) ->
      if err
        res.send 400, error: 'Error'
      else
        res.send project


module.exports = handler
