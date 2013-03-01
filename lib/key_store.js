var crypto = require('crypto');
module.exports = function(){
  var hash = crypto.createHash('sha512');
  hash.update(new Date().toJSON(), 'utf8');
  return hash.digest('hex');
};
