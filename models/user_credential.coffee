BaseModel = require './base'
crypto = require 'crypto'
uuid = require 'uuid'
_ = require 'underscore'

class UserCredential extends BaseModel
  constructor: (options) ->
    super options

    @required = ['userid', 'secret']

    if not @secret
      @genSecret()

  genSecret: () ->
    sha = crypto.createHash 'sha256'
    sha.update "#{uuid.v1()}"
    @secret = sha.digest 'hex'


module.exports = UserCredential
