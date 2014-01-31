var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.runSql(
    'ALTER TABLE usercredentials ADD CONSTRAINT userid_fkey FOREIGN KEY (userid) REFERENCES users (id)',
    callback
  );
};

exports.down = function(db, callback) {
  db.runSql(
    'ALTER TABLE usercredentials DROP CONSTRAINT userid_fkey',
    callback
  );
};
