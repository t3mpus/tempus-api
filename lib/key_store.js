var crypto = require('crypto');
module.exports = function(password){
  var hash = crypto.createHash('sha256');
  var salt = new Date().toJSON();
  hash.update(salt + password, 'utf8');
  return {
    id:hash.digest('hex'),
    salt: salt,
    date_created:salt
  };
};
