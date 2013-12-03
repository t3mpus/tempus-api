var dbm = require('db-migrate');
var type = dbm.dataType;
var async = require('async');

var columnsToRemove = ['userid', '"userId"', '"postHooks"'];
var columnsToAdd = ['"userId"', '"postHooks"'];

exports.up = function(db, callback) {
  function dropConstraint(cb){
    db.runSql('ALTER TABLE projects DROP CONSTRAINT "projects_userid_fkey"', cb);
  }

  function removeColumns(cb) {
    async.eachSeries(columnsToRemove, function(column, cb){
      db.removeColumn('projects', column, cb);
    }, cb);
  }

  async.series([dropConstraint, removeColumns], callback);
};

exports.down = function(db, callback) {
  function addContraint(cb){
    db.runSql('ALTER TABLE projects ADD COLUMN "userid" INTEGER REFERENCES users(id)',cb);
  }

  function addColumns(cb) {

    async.eachSeries(columnsToAdd, function(column, cb){
      db.addColumn('projects', column, {type:'string'}, function(err) {
        cb();
      });
    }, cb);
  }
  async.series([addColumns, addContraint], callback);
};
