var riak = require('riak-js');
/*
 * returns a function that when called returns a riak-js client object connected to the
 * specified host and port (if provided)
 */
var riakjs = function(){
  return riak.getClient({
    host: process.env.RIAK_HOST || '127.0.0.1', port: process.env.RIAK_PORT || 8098
  });
};

module.exports = riakjs;
