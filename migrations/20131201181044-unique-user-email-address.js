var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.changeColumn('users', 'email',
    { type: 'string', notNull: true, unique: true },
    callback);
};

exports.down = function(db, callback) {
  db.changeColumn('users', 'email',
    { type: 'string', notNull: true, unique: false },
    callback);
};
