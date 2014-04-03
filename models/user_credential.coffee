BaseModel = require './base'
crypto = require 'crypto'
uuid = require 'uuid'
_ = require 'underscore'

class UserCredential extends BaseModel
  constructor: (options) ->
    super options

    @required = ['userId', 'secret']

    if not @secret
      @genSecret()

    if not @userId
      @genIdentifier()

  genSecret: () ->
    sha = crypto.createHash 'sha256'
    sha.update "#{uuid.v1()}"
    @secret = sha.digest 'hex'

  genIdentifier: () ->
    @userId = uuid.v1()


module.exports = UserCredential
