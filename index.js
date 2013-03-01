var express = require('express'),
    app = express(),
    appygram = require('appygram');

/*
 * configuration
 */
app.set('title', 'tempus');
appygram.setApiKey(process.env.APPYGRAM_API_KEY || 'a0e802dcff1fe554571ae58b255ca2605451c6b5');
appygram.app_name = app.get('title');

/*
 * app.use
 */
app.use(app.router);
app.use(appygram.errorHandler);


/*
 * routing
 */
app.get('/', function(req, res){
  res.send({title:app.get('title')});
});

/*
 * app.listen on port
 */
var port = process.env.PORT || 3000;
app.listen(port, function(){
  console.log(app.get('title') + ' listening on port ' + port);
});

