BaseModel = require './base'
crypto = require 'crypto'
uuid = require 'uuid'
_ = require 'underscore'

class User extends BaseModel
  constructor: (options) ->
    super options

    @required = ['firstName', 'lastName', 'email', 'hash', 'salt']
    @public = _.without @required, 'hash', 'salt', 'required', 'public'

    if @password
      @makeCredentials @password
      delete @password

  makeCredentials: (password) ->
    sha = crypto.createHash 'sha1'
    salt = uuid.v1() + new Date().toJSON()
    sha.update "#{password}#{salt}"
    hash = sha.digest 'hex'
    if (salt and hash)
      @salt = salt
      @hash = hash

module.exports = User
