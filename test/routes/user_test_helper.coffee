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
  props = _.clone user.public
  props.push 'id'
  hasProps = _.every props, (property)->
    typeof returnedUser[property] isnt 'undefined'
  hasProps.should.be.true

  privateProps = _.difference user.required, user.public
  doesntHaveProps = _.every privateProps, (property) ->
    typeof returnedUser[property] is 'undefined'
  doesntHaveProps.should.be.true

