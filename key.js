var db = require(__dirname + '/lib/db'),
  bucket = 'keys',
  middleware = require(__dirname + '/lib/middleware'),
  tokenish = require('tokenish'),
  tokenishRiak = require('tokenish-riak'),
  tgen = tokenish(tokenishRiak({bucket:'tokens', host: process.env.RIAK_HOST || '127.0.0.1'
    , port: process.env.RIAK_PORT || 8098}));

/*
 * Module that exposes key functionality. Manage keys based on user account.
 * These operations require password verification.
 */
module.exports = function(app){
  app.post('/key', middleware.verifyPassword, function(req, res){
    tgen.createToken(req.id, function(err, token){
      if (err) {
        res.send(400, {error:err});
      } else {
        res.send({token:token});
      }
    });
  });
};
