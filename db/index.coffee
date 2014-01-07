pg = require 'pg'
{dev} = require "#{__dirname}/../database"
devConfig = "postgres://#{dev.user}:#{dev.password}@localhost/#{dev.database}"
constring = process.env.HEROKU_POSTGRESQL_NAVY_URL or devConfig

{EventEmitter} = require 'events'

Database = (callback) ->
  pg.connect constring, callback

class Transaction extends EventEmitter
  constructor: ()->
    Database (err, client, done) =>
      if err
        @emit 'error', err
      else
        @client = client
        @done = done
        @begin()

  begin: ->
    @client.query 'BEGIN', (err)=>
      if err
        @emit 'error', err
      else
        @emit 'begin'

  query: (statement, cb)->
    statement = if typeof statement.toQuery is 'function' then statement.toQuery() else statement
    @client.query statement, (err, rows) =>
      if err
        @emit 'error', err
      else
        cb rows

  rollback: () ->
    @client.query 'ROLLBACK', (err) =>
      @done err
      @emit 'rollback', err

  commit: (obj)->
    @client.query 'COMMIT', (err) =>
      @done()
      @emit 'commit', obj

module.exports = Database

module.exports.Transaction = Transaction

