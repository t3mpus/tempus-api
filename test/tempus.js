var request = require('request'),
  host = process.env.TESTING_HOST || 'http://127.0.0.1:3001',
  assert = require('assert'),
  crypto = require('crypto');

/*
 * Vars used in tests
 */
var key, token;
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
  it('should return the title and version at /', function(done){
    request(host + '/', function(e,r,b){
      var result = JSON.parse(b);
      assert.equal(result.title, 'tempus');
      assert.equal(result.version, require(__dirname + '/../package').version);
      done();
    });
  });
  describe('Users', function(){
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

  });
  describe('Keys', function(){
    it('should throw an error if post key body is missing parameters', function(done){
      request.post(host + '/key', {json:true, body:{}}, function(e,r,b){
        assert.equal(406, r.statusCode);
        assert.ok(b.error);
        done();
      });
    });
    it('should throw an error if id doesn\'t exist', function(done){
      request.post(host + '/key', {json:true, body:{
        id:'nonexsistentdbkey123',
        password:'yeah...no'
      }}, function(e,r,b){
        assert.equal(r.statusCode, 404);
        assert.equal(b.error.notFound, true);
        done();
      });
    });
    it('should throw an error if password is incorrect', function(done){
      request.post(host + '/key', {json:true, body:{
        id:key,
        password:'notmypassword'
      }}, function(e,r,b){
        assert.equal(r.statusCode, 401);
        assert.equal(b.error, 'unauthorized - incorrect credentials');
        done();
      });
    });
  });
  describe('User delete', function(){
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
