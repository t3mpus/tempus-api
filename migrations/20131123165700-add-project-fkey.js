var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.runSql('ALTER TABLE projects ADD COLUMN "userid" INTEGER REFERENCES users(id)', callback);
};

exports.down = function(db, callback) {
  db.removeColumn('projects', 'userid', callback);
};
