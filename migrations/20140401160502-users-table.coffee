dbm = require("db-migrate")
type = dbm.dataType

table = "users"

exports.up = (db, callback) ->
  sql = """
    create table #{table}(
      "id" uuid PRIMARY KEY
              DEFAULT uuid_generate_v4(),
      "firstName" character varying NOT NULL,
      "lastName" character varying NOT NULL,
      "email" character varying NOT NULL UNIQUE,
      "hash" character varying NOT NULL
    )
  """
  db.runSql sql, callback

exports.down = (db, callback) ->
  if process.env.DROP_TABLES
    db.dropTable table, callback
  else
    callback()
