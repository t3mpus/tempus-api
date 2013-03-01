var request = require('request'),
  host = process.env.TESTING_HOST || 'http://127.0.0.1:3001',
  assert = require('assert');
describe('API', function(){
  before(function(done){
    process.env.PORT = 3001;
    var server = require(__dirname + '/../index');
    server(done);
  });
  it('should return the title at /', function(done){
    request(host + '/', function(e,r,b){
      console.log(b);
      var result = JSON.parse(b);
      assert(result.title, 'tempus');
      done();
    });
  });
});
