BaseModel = require './base'
crypto = require 'crypto'
uuid = require 'uuid'
_ = require 'underscore'

class UserCredential extends BaseModel
  constructor: (options) ->
    super options

    @required = ['userId', 'secret', 'algorithm']

    if not @algorithm
      @algorithm = 'sha256'

    if not @secret
      @genSecret()

  genSecret: () ->
    sha = crypto.createHash 'sha256'
    sha.update "#{uuid.v1()}"
    @secret = sha.digest 'hex'


module.exports = UserCredential
