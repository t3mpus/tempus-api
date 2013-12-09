var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.createTable('projects', {
    columns: {
      id:           { type: 'int', primaryKey: true, autoIncrement: true },
      name:         { type: 'string', notNull: true },
      createdDate:  { type: 'datetime', notNull: true },
      postHooks:    { type: 'string' }
    },
    ifNotExists: true
  }, callback);
};

exports.down = function(db, callback) {
  if (process.env.DROP_TABLES == "true") {
    db.dropTable('projects', callback);
  } else {
    callback();
  }
};
