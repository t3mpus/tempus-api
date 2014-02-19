var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.addColumn(
    'usercredentials',
    'user_identifier',
    { type: 'string', notNull: true },
    callback
  )
}

exports.down = function(db, callback) {
  db.removeColumn(
    'usercredentials',
    'user_identifier',
    callback
  )
}
