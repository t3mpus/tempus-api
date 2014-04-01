var async = require('async');

var columns = ['start', 'end']
var table = "time_entries"

function alter(column, type) {
  return "alter table " + table + " alter column \"" + column + "\" type " + type;
}

exports.up = function(db, callback) {
  async.each(columns, function(column, cb) {
    db.runSql(alter(column, "timestamptz"), cb);
  }, callback);
};

exports.down = function(db, callback) {
  async.each(columns, function(column, cb) {
    db.runSql(alter(column, "timestamp"), cb);
  }, callback);
};
