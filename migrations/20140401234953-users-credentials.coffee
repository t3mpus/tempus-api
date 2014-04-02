dbm = require("db-migrate")
async = require 'async'
_ = require 'underscore'
type = dbm.dataType

table = "user_credentials"

exports.up = (db, callback) ->
  t = """
    create table #{table}(
      "secret" character varying,
      "userId" uuid
    )
  """

  r = [
    """
      add constraint #{table}_pkey PRIMARY KEY ("secret", "userId")
    """
    """
      add constraint "user_id_f_key" FOREIGN KEY ("userId") REFERENCES users("id")
    """
  ]

  r = _.map r, (s) -> "alter table #{table} #{s}"

  async.eachSeries _.flatten([t, r]),
    (q, c) -> db.runSql(q, c)
  , callback

exports.down = (db, callback) ->
  if process.env.DROP_TABLES
    db.dropTable table, callback
  else
    callback()
