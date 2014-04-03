BaseController = require "#{__dirname}/base"
sql = require 'sql'
UserCredential = require "#{__dirname}/../models/user_credential"

class UsersController extends BaseController

  user_credential: sql.define
    name: 'usercredentials'
    columns: (new UserCredential).columns()

  create: (userId, callback)->
    userCredential = new UserCredential
      userId: userId
    statement = @user_credential
      .insert(userCredential.requiredObject())
      .returning '*'

    @query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new UserCredential rows[0]

  getOne: (userId, callback)->
    statement = @user_credential
      .select @user_credential.star()
      .where @user_credential.userId.equals userId
      .limit 1
      .from @user_credential

    @query statement, (err, rows) ->
      if err
        callback err
      else
        callback err, new UserCredential rows[0]

  deleteSql: (userId)->
    statement = @user_credential
      .delete()
      .where @user_credential.userId.equals userId
      .from @user_credential

  delete: (userId, callback)->
    statement = @deleteSql userId

    @queryWithResult statement, (err, result) ->
      if err
        return callback err
      if result.rowCount > 0
        callback()
      else
        callback new Error 'no user credential deleted'


module.exports = UsersController.get()
