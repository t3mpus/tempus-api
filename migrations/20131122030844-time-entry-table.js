var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.createTable('timeEntries', {
    columns: {
      id:       { type: 'int', primaryKey: true, autoIncrement: true },
      start:    { type: 'datetime', notNull: true },
      end:      { type: 'datetime', notNull: true },
      message:  { type: 'string' }
    },
    ifNotExists: true
  }, callback);
};

exports.down = function(db, callback) {
  if (process.env.DROP_TABLES == "true") {
    db.dropTable('timeEntries', callback);
  } else {
    callback();
  }
};
