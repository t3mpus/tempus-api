var request = require('request'),
  host = process.env.TESTING_HOST || 'http://127.0.0.1:3001',
  assert = require('assert');
describe('API', function(){
  before(function(done){
    process.env.PORT = process.env.TESTING_PORT || 3001;
    var server = require(__dirname + '/../index');
    server(done);
  });
  it('should return the title at /', function(done){
    request(host + '/', function(e,r,b){
      var result = JSON.parse(b);
      assert(result.title, 'tempus');
      done();
    });
  });
  describe('Users', function(){
    var key = '';
    it('should add a new user', function(done){
      request.post(host + '/user', {json:true, body:{
        name:{
          first:'will',
          last:'laurance',
          prefix:'mr.'
        },
        email:'w.laurance@gmail.com',
      }}, function(e,r,b){
        assert.notEqual(b.key, undefined);
        key = b.key;
        done();
      });
    });
    it('should get user information', function(done){
      request(host + '/user/' + key, {json:true}, function(e,r,b){
        assert.equal(b.name.first, 'will');
        assert.equal(b.name.last, 'laurance');
        assert.equal(b.name.prefix, 'mr.');
        assert.equal(b.email, 'w.laurance@gmail.com');
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
});
