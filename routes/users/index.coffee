UsersController = require "#{__dirname}/../../controllers/users"

handler = (app)->

  app.get '/users', (req, res)->
    UsersController.getAll (err, users)->
      res.send users:users

module.exports = handler
