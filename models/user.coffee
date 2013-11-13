_ = require 'underscore'
crypto = require 'crypto'
uuid = require 'uuid'

class User
  constructor: (options) ->
    _.each options, (v, k) =>
      @[k] = v

    @required = ['firstName', 'lastName', 'email', 'hash', 'salt']

  makeCredentials: (password) ->
    sha = crypto.createHash 'sha1'
    salt = uuid.v1()
    sha.update "#{password}#{salt}"
    hash = sha.digest 'hex'
    if (salt and hash)
      @salt = salt
      @hash = hash

  valid: () ->
    _.every @required, (property) =>
      typeof @[property] isnt 'undefined'

module.exports = User
