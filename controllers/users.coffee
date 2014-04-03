BaseController = require "#{__dirname}/base"
sql = require 'sql'
async = require 'async'
User = require "#{__dirname}/../models/user"
UserCredentialsController = require "#{__dirname}/../controllers/user_credentials"

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

  getOneWithCredentials: (key, callback)->
    {user_credential} = UserCredentialsController
    statement = @user
      .select @user.star(), user_credential.star()
      .where user_credential.userId.equals key
      .from(
        @user
          .join user_credential
          .on @user.id.equals user_credential.userId
      )
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
    t = @transaction()
    deleteUser = @user.delete()
      .where @user.id.equals key
    deleteUserCredentials = UserCredentialsController.deleteSql key
    start = ->
      async.eachSeries [deleteUserCredentials, deleteUser],
        (s, cb)->
          t.query s, () ->
            cb()
        , ->
          t.commit()

    t.on 'begin', start
    t.on 'error', console.log
    t.on 'commit', ->
      callback()
    t.on 'rollback', ->
      callback new Error "Could not delete user with id #{key}"


module.exports = UsersController.get()
