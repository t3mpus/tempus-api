var crypto = require('crypto'),
  uuid = require('uuid');
/*
 * Exports a function that does a sha sum and returns the start of a user object
 */
module.exports = function(password){
  var hash = crypto.createHash('sha256');
  var salt = new Date().toJSON();
  hash.update(salt + password, 'utf8');
  return {
    salt: salt,
    date_created: salt,
    hash_pass: hash.digest('hex'),
    id: uuid.v1()
  };
};
