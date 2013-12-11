riakjs = require 'riak-js'

config = {}

module.exports =
  getClient: () ->
    riakjs.getClient config

