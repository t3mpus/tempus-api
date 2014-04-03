dbm = require("db-migrate")
async = require 'async'
_ = require 'underscore'
type = dbm.dataType

table = "users_projects"

exports.up = (db, callback) ->
  t = """
    create table #{table}(
      "userId" uuid NOT NULL,
      "projectId" uuid NOT NULL
    )
  """

  r = [
    """
      add constraint #{table}_pkey PRIMARY KEY ("userId", "projectId")
    """
    """
      add constraint "user_id_f_key" FOREIGN KEY ("userId") REFERENCES users("id")
    """
    """
      add constraint "project_id_f_key" FOREIGN KEY ("projectId") REFERENCES projects("id")
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
