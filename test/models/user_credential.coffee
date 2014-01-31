UserCredential = require "#{__dirname}/../../models/user_credential"
should = require 'should'

describe 'User Credential', ->
  it 'should be able to construct a user credential', ->
    uc = new UserCredential
      userId: 5
    uc.userId.should.be.equal 5
    uc.should.have.property 'secret'
    uc.should.have.property 'algorithm', 'sha256'

  it 'should allow the generated properties to be passed in', ->
    us = new UserCredential
      userId: 5
      id: 1324
      secret: 'super secret key'

    us.userId.should.be.equal 5
    us.secret.should.be.equal 'super secret key'
    us.should.have.property 'algorithm', 'sha256'
