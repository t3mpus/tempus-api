var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.runSql('ALTER TABLE timeentries ADD COLUMN "projectid" INTEGER REFERENCES projects(id)', callback);
};

exports.down = function(db, callback) {
  db.removeColumn('timeentries', 'projectid', callback);
};
