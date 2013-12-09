var dbm = require('db-migrate');
var type = dbm.dataType;

exports.up = function(db, callback) {
  db.dropTable('timeentries', callback);
};

exports.down = function(db, callback) {
  db.createTable('timeEntries', {
    columns: {
      id:       { type: 'int', primaryKey: true, autoIncrement: true },
      start:    { type: 'datetime', notNull: true },
      end:      { type: 'datetime', notNull: true },
      message:  { type: 'string' }
    },
    ifNotExists: true
  }, function() {
    db.runSql('ALTER TABLE timeentries ADD COLUMN "projectid" INTEGER REFERENCES projects(id)', callback);
  });
};
