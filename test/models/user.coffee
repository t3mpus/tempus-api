User = require '../../models/user'
should = require 'should'

makeTestUser = -> new User
  firstName: 'Test'
  lastName: 'User'
  email: 'test@user.com'

describe 'User Model', ->
  it 'should be able to construct a new user', ->
    testUser = new User
    testUser.should.not.be.equal undefined

  it 'should be able to construct a new user with params', ->
    testuser = makeTestUser()
    testuser.firstName.should.be.equal 'Test'
    testuser.lastName.should.be.equal 'User'
    testuser.email.should.be.equal 'test@user.com'

  it 'should be able to add login credentials', ->
    testuser = makeTestUser()
    testuser.makeCredentials 'password!@#$'
    testuser.should.have.property 'hash'
    testuser.should.have.property 'salt'
    testuser.should.not.have.property 'password'
    testuser.valid().should.be.true
