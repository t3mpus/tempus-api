var dbm = require('db-migrate');
var type = dbm.dataType;

var table = "users";

exports.up = function(db, callback) {
  db.removeColumn(table, "salt", callback);
};

exports.down = function(db, callback) {
  db.addColumn(table, 'salt', {
    type: 'string',
    notNull: true,
    defaultValue: ''
  }, callback)
};
