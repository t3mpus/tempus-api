var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.createTable('usercredentials', {
    columns: {
      secret:   { type: 'string', primaryKey: true },
      userid:   { type: 'int', primaryKey: true }
    },
    ifNotExists: true
  }, callback);
};

exports.down = function(db, callback) {
  if (process.env.DROP_TABLES == "true") {
    db.dropTable('usercredentials', callback);
  } else {
    callback();
  }
};
