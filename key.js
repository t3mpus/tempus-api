var db = require(__dirname + '/lib/db'),
  bucket = 'keys';
module.exports = function(app){
  app.post('/key', function(req, res){
    res.send({
      token:'blah'
    });
  });
};
