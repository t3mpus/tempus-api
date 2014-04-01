dbm = require("db-migrate")
type = dbm.dataType

exports.up = (db, callback) ->
  db.runSql 'create extension if not exists "uuid-ossp"', callback

exports.down = (db, callback) ->
  db.runSql 'drop extension if exists "uuid-ossp"', callback
