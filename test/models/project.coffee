Project = require '../../models/project'
should = require 'should'

describe 'Project', ->
  makeProject = ->
    new Project
      name: 'my project'
      createdDate: new Date()

  it 'should validate a model', ->
    makeProject().validate().should.be.true
