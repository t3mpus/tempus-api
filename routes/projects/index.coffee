ProjectsController = require "#{__dirname}/../../controllers/projects"
Project = require "#{__dirname}/../../models/project"

handler = (app) ->

  app.get '/projects', (req, res) ->
    ProjectsController.getAll (err, projects) ->
      if err
        res.send 400, error: 'Error'
      else
        res.send projects:projects

  app.post '/projects', (req, res) ->
    project = new Project req.body
    if project.validate()
      ProjectsController.create project, (err, project) ->
        if err
          res.send 400, error: 'Error'
        else
          res.send project
    else
      res.send 400, error: 'Error'


module.exports = handler
