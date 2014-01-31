HawkStrategy = require 'passport-hawk'
UsersController = require './controllers/users'

HAWK_ALG = 'sha256'

module.exports = (passport) ->
  strat_name = 'hawk-strategy'
  passport.use strat_name, new HawkStrategy (token, done)->
    console.log(token)
    UsersController.getOne token, (err, user)->
      if err
        return done err
      else
        done null,
          key: user.secret,
          algorithm: HAWK_ALG,
          user: user

  return strat_name
