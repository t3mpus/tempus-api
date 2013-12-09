Singleton = require 'singleton'
db = require "#{__dirname}/../db"
_ = require 'underscore'

class BaseController extends Singleton
  query: (statement, callback, rows = yes)->
    db (err, client, done) ->
      if err
        return callback err
      client.query statement.toQuery(), (err, result)->
        done()
        callback err, if rows then result?.rows else result

  queryWithResult: (statement, callback)->
    @query statement, callback, no

  transaction: (cb)->
    t = new db.Transaction (()-> cb(t))

module.exports = BaseController

