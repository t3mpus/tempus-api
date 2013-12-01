_ = require 'underscore'
UsersController = require "#{__dirname}/../../controllers/users"
User = require "#{__dirname}/../../models/user"

handler = (app)->

  app.get '/users', (req, res)->
    UsersController.getAll (err, users)->
      res.send users: _.map users, (user)-> new User(user).publicObject()

  app.post '/users', (req, res)->
    user = new User req.body
    if user.validate()
      UsersController.create user, (err, user)->
        res.send user.publicObject()
    else
      res.send 400, error: user.errors()

  app.get '/users/:id', (req, res)->
    UsersController.getOne req.params.id, (err, user)->
      if err
        res.send 404, error: "User with id #{id} not found"
      else
        res.send user.publicObject()


module.exports = handler
