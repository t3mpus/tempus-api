var assert = require('assert')
  , should = require('should');

describe('Singleton', function() {
  it('should return the same object', function(done) {
    var test1 = require('./singleton-class');
    var test2 = require('./singleton-class')
    assert(test1.instantiated_time === test2.instantiated_time, true);
    done();
  });
  it('should realize changes in all references, because it is the same object', function(done){
    var test1 = require('./singleton-class');
    assert(test1.testString, 'hello');
    test1.testString = 'haha test2';
    assert(test1.testString === 'haha test2', true);
    var test2 = require('./singleton-class');
    assert(test2.testString === 'haha test2', true);
    test2.testString = 'argggs';
    assert(test1.testString === 'argggs', true);
    var test3 = require ('./singleton-class');
    assert(test3.testString === 'argggs', true);
    done();
  });
});
