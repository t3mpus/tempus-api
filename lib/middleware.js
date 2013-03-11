var db = require(__dirname + '/db'),
  crypto = require('crypto');
/*
 * verifyPassword will look up the computed hash of the user at their key.
 * It will send back the appropriate response if necessary or call the next
 * function
 */
exports.verifyPassword = function(req, res, next){
  if (req.body.id && req.body.password) {
    db().get('users', req.body.id, function(e,b,m){
      if (e) {
        res.send(e.statusCode, {error:e});
      } else {
        var hash = crypto.createHash('sha256');
        hash.update(b.salt + req.body.password, 'utf8');
        if (hash.digest('hex') === b.hash_pass) {
          next();
        } else {
          res.send(401, {error:'unauthorized - incorrect credentials'});
        }
      }
    });
  } else {
    res.send(406, {error:'missing parameters' + (req.body.id ? '' : ' id') + (req.body.password ? '' : ' password')});
  }
};
