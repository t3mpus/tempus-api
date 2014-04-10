dbm = require("db-migrate")
async = require 'async'
_ = require 'underscore'
type = dbm.dataType

table = "time_entries"
constraint = "positive_duration"

exports.up = (db, callback) ->
  r = [
    """
      add CONSTRAINT #{constraint} CHECK ( "duration" > 0 )
    """
  ]

  r = _.map r, (s) -> "alter table #{table} #{s}"

  async.eachSeries _.flatten([r]),
    (q, c) -> db.runSql(q, c)
  , callback

exports.down = (db, callback) ->

  db.runSql("alter table #{table} drop constraint #{constraint}", callback)
