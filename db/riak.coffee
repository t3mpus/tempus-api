riakjs = require 'riak-js'

module.exports =
  getClient: () ->
    config = {}
    config.host = process.env.RIAK_HOST || '127.0.0.1'
    config.port = process.env.RIAK_PORT || 8098
    config.scheme = process.env.RIAK_SCHEME || 'http'
    config.user = process.env.RIAK_USER
    config.password = process.env.RIAK_PASSWORD
    if config.user and config.password
      config.headers =
        Authorization: "Basic #{new Buffer("#{conf.user}:#{conf.password}").toString 'base64'}"
    riakjs.getClient config


