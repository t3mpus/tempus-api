BaseModel = require './base'
crypto = require 'crypto'
uuid = require 'uuid'
_ = require 'underscore'

class UserCredential extends BaseModel
  constructor: (options) ->
    super options

    @required = ['userId', 'secret', 'user_identifier']

    if not @secret
      @genSecret()

    if not @user_identifier
      @genIdentifier()

  genSecret: () ->
    sha = crypto.createHash 'sha256'
    sha.update "#{uuid.v1()}"
    @secret = sha.digest 'hex'

  genIdentifier: () ->
    @user_identifier = uuid.v1()


module.exports = UserCredential
