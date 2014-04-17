dbm = require("db-migrate")
async = require 'async'
_ = require 'underscore'
type = dbm.dataType

table = "time_entries"
constraint = "start_and_end_or_duration"
A = """"start" <> NULL and "end" <> NULL"""
B = """"duration" <> NULL"""

exports.up = (db, callback) ->
  r = [
    """
      add CONSTRAINT #{constraint} CHECK ( (#{A} AND NOT #{B}) or ( NOT #{A} AND #{B}) )
    """
  ]

  r = _.map r, (s) -> "alter table #{table} #{s}"

  async.eachSeries _.flatten([r]),
    (q, c) -> db.runSql(q, c)
  , callback

exports.down = (db, callback) ->

  db.runSql("alter table #{table} drop constraint #{constraint}", callback)
