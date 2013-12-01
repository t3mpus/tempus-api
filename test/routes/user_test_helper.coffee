async = require 'async'
should = require 'should'
_ = require 'underscore'
User = require "#{__dirname}/../../models/user"

exports.addUsers = (done) ->
  done()

exports.isEqual = (users) ->
  yes

exports.users = []

exports.validate = (returnedUser) ->
  user = new User returnedUser
  _.every user.public, (property)->
    typeof returnedUser[property] isnt 'undefined'

