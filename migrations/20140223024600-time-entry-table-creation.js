var dbm = require('db-migrate');
var type = dbm.dataType;

var dbname = "time_entries"

exports.up = function(db, callback) {
  db.createTable(dbname, {
    columns: {
      id:         { type: 'int', primaryKey: true, autoIncrement: true },
      start:      { type: 'timestamp', notNull: true },
      end:        { type: 'timestamp', notNull: true },
      message:    { type: 'string' }
    },
    ifNotExists: true
  }, callback)
};

exports.down = function(db, callback) {
  if (process.env.DROP_TABLES) {
    db.dropTable(dbname, callback)
  } else {
    callback()
  }
};
