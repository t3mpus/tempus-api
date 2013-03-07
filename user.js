var db = require(__dirname + '/lib/db'),
  bucket = 'users',
  key_store = require(__dirname + '/lib/key_store'),
  deepmerge = require('deepmerge');
module.exports = function(app){
  /*
   * standard RESTful api for user
   */
  app.get('/user/:id', function(req, res){
    get(req.params.id, function(err, user, meta){
      res.send(meta.statusCode, err || user);
    });
  });

  app.post('/user', function(req, res){
    var build = key_store(req.body.password);
    db().save(bucket, build.id, deepmerge(req.body, build), function(err, user, meta){
      res.send(err ? {error:err} : {key:meta.key});
    });
  });

  app.put('/user/:id', function(req, res){
    get(req.params.id, function(err, user, meta){
      db().save(bucket, req.params.id, deepmerge(user, req.body), function(err, user, meta){
        res.send(err ? {error:err} : meta);
      });
    });
  });

  app.delete('/user/:id', function(req, res){
    db().remove(bucket, req.params.id, function(err, user, meta){
      res.send(err ? {error:err} : meta);
    });
  });
};

var get = function(id, callback){
  db().get(bucket, id, callback);
};
