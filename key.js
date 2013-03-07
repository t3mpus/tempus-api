var db = require(__dirname + '/lib/db'),
  bucket = 'keys',
  middleware = require(__dirname + '/lib/middleware');
module.exports = function(app){
  app.post('/key', middleware.verifyPassword, function(req, res){
    res.send({
      token:'blah'
    });
  });
};
