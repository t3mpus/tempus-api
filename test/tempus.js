var request = require('request'),
  host = process.env.TESTING_HOST || 'http://127.0.0.1:3001',
  assert = require('assert'),
  crypto = require('crypto');
describe('API', function(){
  before(function(done){
    if(!process.env.TESTING_HOST){
      process.env.PORT = process.env.TESTING_PORT || 3001;
      var server = require(__dirname + '/../index');
      server(done);
    } else {
      done();
    }
  });
  it('should return the title at /', function(done){
    request(host + '/', function(e,r,b){
      var result = JSON.parse(b);
      assert(result.title, 'tempus');
      done();
    });
  });
  describe('Users', function(){
    var key, token;
    it('should add a new user', function(done){
      request.post(host + '/user', {json:true, body:{
        name:{
          first:'will',
          last:'laurance',
          prefix:'mr.'
        },
        email:'w.laurance@gmail.com',
        password:'password123'
      }}, function(e,r,b){
        assert.notEqual(b.key, undefined);
        key = b.key;
        done();
      });
    });
    it('should request a permanent session token', function(done){
      request.post(host + '/key', {json:true, body:{
        id:key,
        password:'password123'
      }}, function(e,r,b){
        assert.ok(b.token);
        token = b.token;
        done();
      });
    });
    it('should get user information', function(done){
      request(host + '/user/' + key, {json:true}, function(e,r,b){
        assert.equal(b.name.first, 'will');
        assert.equal(b.name.last, 'laurance');
        assert.equal(b.name.prefix, 'mr.');
        assert.equal(b.email, 'w.laurance@gmail.com');
        assert.equal((new Date() >= new Date(b.date_created)), true);
        assert.ok(b.hash_pass);
        assert.ok(b.id);
        assert.ok(b.salt);
        var hash = crypto.createHash('sha256');
        hash.update(b.salt + 'password123', 'utf8');
        assert.equal(b.hash_pass, hash.digest('hex'));
        done();
      });
    });
    it('should update user information', function(done){
      request.put(host + '/user/' + key, {json:true, body:{
        name:{
          first:'bill'
        },
        email:'w.laurance@yahoo.com'
      }}, function(e,r,b){
        assert.equal(e,undefined);
        request.get(host + '/user/' + key, {json:true}, function(e,r,b){
          assert.equal(b.name.first, 'bill');
          assert.equal(b.name.last, 'laurance');
          assert.equal(b.name.prefix, 'mr.');
          assert.equal(b.email, 'w.laurance@yahoo.com');
          done();
        });
      });
    });
    it('should delete user information', function(done){
      request.del(host + '/user/' + key, {json:true}, function(e,r,b){
        request.get(host + '/user/' + key, {json:true}, function(e,r,b){
          assert.equal(b.message, 'not found');
          assert.equal(r.statusCode, 404);
          assert.equal(b.notFound, true);
          done();
        });
      });
    });
  });
});
