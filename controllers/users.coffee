BaseController = require "#{__dirname}/base"
sql = require 'sql'
User = require "#{__dirname}/../models/user"

class UsersController extends BaseController

  user: sql.define
    name: 'users'
    columns: (new User).columns()

  getAll: (callback)->
    statement = @user.select(@user.star()).from(@user)
    @query statement, callback

  getOne: (key, callback)->
    statement = @user.select(@user.star()).from(@user)
      .where(@user.id.equals key)
    @query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new User rows[0]

  create: (userParam, callback)->
    statement = (@user.insert userParam.requiredObject()).returning '*'
    @query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new User rows[0]

  deleteOne: (key, callback)->
    statement = @user.delete().where(@user.id.equals(key))
    @queryWithResult statement, (err, result)->
      if err
        return callback err
      if result.rowCount > 0
        callback()
      else
        callback new Error 'no user deleted'

module.exports = UsersController.get()
