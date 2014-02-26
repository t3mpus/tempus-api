async = require 'async'
should = require 'should'
_ = require 'underscore'
uuid = require 'uuid'
request = require 'request'
User = require "#{__dirname}/../../models/user"
options = require "#{__dirname}/../options"
base = require "#{__dirname}/../base"

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


exports.makeUser = (callback) ->
  ops = options()
  ops.body =
    firstName: 'Test'
    lastName: 'User'
    email: uuid.v1() + 'super-awesome-email@email.com'
    password: 'keyboard cats'
  request.post (base '/users'), ops, (e,r,b)->
    r.statusCode.should.be.equal 200
    callback b
