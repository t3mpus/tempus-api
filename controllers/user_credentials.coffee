BaseController = require "#{__dirname}/base"
sql = require 'sql'
UserCredential = require "#{__dirname}/../models/user_credential"

class UsersController extends BaseController

  user_credential: sql.define
    name: 'usercredentials'
    columns: (new UserCredential).columns()

  create: (userId, callback)->
    userCredential = new UserCredential
      userid: userId
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
      .where @user_credential.userid.equals userId
      .limit 1
      .from @user_credential

    @query statement, (err, rows) ->
      if err
        callback err
      else
        callback err, new UserCredential rows[0]

module.exports = UsersController.get()
