dbm = require("db-migrate")
type = dbm.dataType

table = "projects"

exports.up = (db, callback) ->
  sql = """
    create table #{table}(
      "id" uuid PRIMARY KEY
              DEFAULT uuid_generate_v4(),
      "name" character varying NOT NULL,
      "createdDate" timestamptz NOT NULL
    )
  """
  db.runSql sql, callback

exports.down = (db, callback) ->
  if process.env.DROP_TABLES
    db.dropTable table, callback
  else
    callback()
