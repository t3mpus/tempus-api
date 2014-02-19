UserCredential = require "#{__dirname}/../../models/user_credential"
should = require 'should'

describe 'User Credential', ->
  it 'should be able to construct a user credential', ->
    uc = new UserCredential
      userid: 5
    uc.userid.should.be.equal 5
    uc.should.have.property 'secret'
    uc.should.have.property 'user_identifier'

  it 'should allow the generated properties to be passed in', ->
    us = new UserCredential
      userid: 5
      secret: 'super secret key'
      user_identifier: 'facebook'

    us.userid.should.be.equal 5
    us.secret.should.be.equal 'super secret key'
    us.user_identifier.should.be.equal 'facebook'
