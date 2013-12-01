sql = require 'sql'
db = require "#{__dirname}/../db"
User = require "#{__dirname}/../models/user"

user = sql.define
  name: 'users'
  columns: (new User).columns()

query = (statement, callback)->
  db (err, client, done) ->
    if err
      return callback err
    client.query statement.toQuery(), (err, result)->
      done()
      callback err, result?.rows

UsersController =
  getAll: (callback)->
    sqlStatement = user.select(user.star()).from(user)
    query sqlStatement, callback

  getOne: (key, callback)->

  create: (userParam, callback)->
    sqlStatement = (user.insert userParam.requiredObject()).returning 'id'
    query sqlStatement, (err, id)->
      callback err, id?[0]?['id']

module.exports = UsersController
