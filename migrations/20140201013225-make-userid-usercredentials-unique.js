var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.runSql(
    'ALTER TABLE usercredentials ADD CONSTRAINT userid_unique UNIQUE (userid)',
    callback
  );
};

exports.down = function(db, callback) {
  db.runSql(
    'ALTER TABLE usercredentials DROP CONSTRAINT userid_unique',
    callback
  );
};
