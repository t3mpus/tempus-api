_ = require 'underscore'
UsersController = require "#{__dirname}/../../controllers/users"
UserCredentialsController = require "#{__dirname}/../../controllers/user_credentials"
User = require "#{__dirname}/../../models/user"

handler = (app, {passport, strategy})->

  auth = ->
    passport.authenticate strategy, session: false

  protect = (req, res, next) ->
    auth_id = req.user.id
    req_id = req.params.id
    if auth_id and req_id
      if auth_id is req_id
        next()
      else
        res.send 403
    else
      res.send 403

  app.post '/users', (req, res)->
    user = new User req.body
    if user.validate()
      UsersController.create user, (err, user)->
        if err
          res.send 400, error: 'user already exists'
        else
          pub_user = user.publicObject()
          UserCredentialsController.create pub_user.id, (err, credentials) ->
            if (err)
              res.send 400, error: 'user credentials error'
            else
              pub_user.credentials = credentials.publicObject()
              res.send pub_user
    else
      res.send 400, error: "could not create user"

  app.get '/users/:id', auth(), protect, (req, res)->
    UsersController.getOne req.params.id, (err, user)->
      if err or not user.validate()
        res.send 404, error: "User with id #{req.params.id} not found"
      else
        res.send user.publicObject()

  app.delete '/users/:id', auth(), protect, (req, res)->
    UsersController.deleteOne req.params.id, (err) ->
      if err
        res.send 404, error: "User with id #{req.params.id} not found"
      else
        res.send 200

  app.get '/users/:id/credentials', auth(), protect, (req, res)->
    UserCredentialsController.getOne req.params.id, (err, credentials) ->
      if err
        res.send 404, error: "No credentials set for user #{req.parmas.id}"
      else
        res.send credentials.publicObject()

  app.post '/users/:id/credentials', auth(), protect, (req, res)->
    UserCredentialsController.create req.params.id, (err, credentials)->
      if err
        res.send 404, error: err
      else
        res.send credentials.publicObject()

  app.delete '/users/:id/credentials', auth(), protect, (req, res)->
    UserCredentialsController.delete req.params.id, (err)->
      if err
        res.send 404, error: err
      else
        res.send 200

module.exports = handler
