sql = require 'sql'
db = require "#{__dirname}/../db"
User = require "#{__dirname}/../models/user"

user = sql.define
  name: 'users'
  columns: (new User).columns()

query = (string, callback)->
  db (err, client, done) ->
    if err
      return callback err
    client.query string, (err, result)->
      done()
      callback err, result?.rows

UsersController =
  getAll: (callback)->
    sqlString = user.select(user.star()).from(user).toQuery().text
    query sqlString, callback

  getOne: (key, callback)->

module.exports = UsersController
