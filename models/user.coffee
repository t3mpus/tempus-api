BaseModel = require './base'
_ = require 'underscore'
bcrypt = require 'bcrypt'

class User extends BaseModel
  constructor: (options) ->
    super options

    @required = ['firstName', 'lastName', 'email', 'hash']
    @public = _.without @required, 'hash', 'required', 'public'

    if @password
      @makeCredentials @password
      delete @password

  makeCredentials: (password) ->
    @hash = bcrypt.hashSync password, bcrypt.genSaltSync(10)

module.exports = User
