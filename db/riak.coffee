riakjs = require 'riak-js'



module.exports =
  getClient: () ->
    config = {}
    if process.env.NODE_ENV?.toLowerCase() is 'staging' or process.env.RIAK_ENV?.toLowerCase() is 'staging'
      conf = (require "#{__dirname}/../database.json").riak.staging
      config.host = conf.host
      config.port = conf.port
      config.scheme = conf.scheme
      if conf.user and conf.password
        config.headers =
          Authorization: "Basic #{new Buffer("#{conf.user}:#{conf.password}").toString 'base64'}"
    riakjs.getClient config


