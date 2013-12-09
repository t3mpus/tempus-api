var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.createTable('users', {
    columns: {
      id:         { type: 'int', primaryKey: true, autoIncrement: true },
      firstName:  { type: 'string', notNull: true},
      lastName:   { type: 'string', notNull: true},
      email:      { type: 'string', notNull: true},
      hash:       { type: 'string', notNull: true},
      salt:       { type: 'string', notNull: true}
    },
    ifNotExists: true
  }, callback);
};

exports.down = function(db, callback) {
  db.dropTable('users', callback);
};
