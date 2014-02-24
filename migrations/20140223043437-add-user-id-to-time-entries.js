var dbm = require('db-migrate');
var type = dbm.dataType;

var dbname = "time_entries"

exports.up = function(db, callback) {
  db.runSql(
    'alter table ' + dbname + ' add column "userId" integer not null references users(id)',
    callback
  )
};

exports.down = function(db, callback) {
  db.runSql(
    'alter table ' + dbname + ' drop column "userId"',
    callback
  )
};
