var dbm = require('db-migrate');
var type = dbm.dataType;
var async = require('async');

exports.up = function(db, callback) {
  function run(sql, cb) {
    db.runSql(sql,cb);
  }
  var constraints = [
    "ALTER TABLE usersprojects ADD CONSTRAINT userid_fkey FOREIGN KEY (userid) REFERENCES users (id)",
    "ALTER TABLE usersprojects ADD CONSTRAINT projectid_fkey FOREIGN KEY (projectid) REFERENCES projects (id)"
  ];
  async.eachSeries(constraints, run, callback);
};

exports.down = function(db, callback) {
  function run(sql, cb) {
    db.runSql(sql, cb);
  }
  var constraints = [
    "ALTER TABLE usersprojects DROP CONSTRAINT userid_fkey",
    "ALTER TABLE usersprojects DROP CONSTRAINT projectid_fkey"
  ];
  async.eachSeries(constraints, run, callback);
};
