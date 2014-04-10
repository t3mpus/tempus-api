dbm = require("db-migrate")
async = require 'async'
_ = require 'underscore'
type = dbm.dataType

table = "time_entries"
constraint = "start_and_end_or_duration"

exports.up = (db, callback) ->
  r = [
    """
      add CONSTRAINT #{constraint} CHECK ( ( "start" <> NULL and "end" <> NULL ) or ( "duration" <> NULL ) )
    """
  ]

  r = _.map r, (s) -> "alter table #{table} #{s}"

  async.eachSeries _.flatten([r]),
    (q, c) -> db.runSql(q, c)
  , callback

exports.down = (db, callback) ->

  db.runSql("alter table #{table} drop constraint #{constraint}", callback)
