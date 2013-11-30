UsersController = require "#{__dirname}/../../controllers/users"
User = require "#{__dirname}/../../models/user"

handler = (app)->

  app.get '/users', (req, res)->
    UsersController.getAll (err, users)->
      res.send users:users

  app.post '/users', (req, res)->
    user = new User req.body
    if user.validate()
      UsersController.create user, (err, user)->
        res.send user.public()
    else
      res.send 400, error: user.errors()


module.exports = handler
