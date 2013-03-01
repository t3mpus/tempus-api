var riak = require('riak-js');
var riakjs = function(){
  return riak.getClient({
    host: process.env.RIAK_HOST || '127.0.0.1', port: process.env.RIAK_PORT || 8098
  });
};

module.exports = riakjs;
