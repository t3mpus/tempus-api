pg = require 'pg'
{dev} = require "#{__dirname}/../database"
devConfig = "postgres://#{dev.user}:#{dev.password}@localhost/#{dev.database}"
constring = process.env.HEROKU_POSTGRESQL_RED_URL or devConfig

module.exports = (callback) ->
  pg.connect constring, callback

