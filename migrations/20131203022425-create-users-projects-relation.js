var dbm = require('db-migrate');
var type = dbm.dataType;

var n = "usersprojects";
exports.up = function(db, callback) {
  db.createTable(n, {
    userid: { type: 'int', primaryKey: true },
    projectid: { type: 'int', primaryKey: true }
  }, callback);
};

exports.down = function(db, callback) {
  if (process.env.DROP_TABLES == "true") {
    db.dropTable(n, callback);
  } else {
    callback();
  }
};
