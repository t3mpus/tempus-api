var express = require('express'),
    app = express(),
    appygram = require('appygram');
/*
 * exports
 */
var ready;
module.exports = function(done){ready = done;};
/*
 * configuration
 */
app.set('title', 'tempus');
app.set('version', require('./package').version);
appygram.setApiKey(process.env.APPYGRAM_API_KEY || 'a0e802dcff1fe554571ae58b255ca2605451c6b5');
appygram.app_name = app.get('title');

/*
 * app.use
 */
app.use(express.bodyParser());
app.use(app.router);
app.use(appygram.errorHandler);

/*
 * routing
 */
app.get('/', function(req, res){
  res.send({title:app.get('title'), version:app.get('version')});
});
/*
 * pass app to exported model functions
 */
require(__dirname + '/user')(app);
require(__dirname + '/key')(app);

/*
 * app.listen on port
 */
var port = process.env.PORT || 3000;
app.listen(port, function(){
  console.log(app.get('title') + ' listening on port ' + port);
  if (typeof ready !== 'undefined'){
    ready();
  }
});
