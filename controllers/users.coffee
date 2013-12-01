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
    statement = user.select(user.star()).from(user)
    query statement, callback

  getOne: (key, callback)->
    statement = user.select(user.star()).from(user)
      .where(user.id.equals key)
    query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new User rows[0]

  create: (userParam, callback)->
    statement = (user.insert userParam.requiredObject()).returning '*'
    query statement, (err, rows)->
      if err
        callback err
      else
        callback err, new User rows[0]

module.exports = UsersController
