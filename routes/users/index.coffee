_ = require 'underscore'
UsersController = require "#{__dirname}/../../controllers/users"
UserCredentialsController = require "#{__dirname}/../../controllers/user_credentials"
User = require "#{__dirname}/../../models/user"

handler = (app)->

  app.get '/users', (req, res)->
    UsersController.getAll (err, users)->
      res.send _.map users, (user)-> new User(user).publicObject()

  app.post '/users', (req, res)->
    user = new User req.body
    if user.validate()
      UsersController.create user, (err, user)->
        if err
          res.send 400, error: 'user already exists'
        else
          res.send user.publicObject()
    else
      res.send 400, error: user.errors()

  app.get '/users/:id', (req, res)->
    UsersController.getOne req.params.id, (err, user)->
      if err or not user.validate()
        res.send 404, error: "User with id #{req.params.id} not found"
      else
        res.send user.publicObject()

  app.delete '/users/:id', (req, res)->
    UsersController.deleteOne req.params.id, (err) ->
      if err
        res.send 404, error: "User with id #{req.params.id} not found"
      else
        res.send 200

  app.get '/users/:id/credentials', (req, res)->
    UserCredentialsController.getOne req.params.id, (err, credentials) ->
      if err
        res.send 404, error: "No credentials set for user #{req.parmas.id}"
      else
        res.send credentials.publicObject()

  app.post '/users/:id/credentials', (req, res)->
    UserCredentialsController.create req.params.id, (err, credentials)->
      if err
        res.send 404, error: err
      else
        res.send credentials.publicObject()

module.exports = handler
