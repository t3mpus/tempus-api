Project = require '../../models/project'
should = require 'should'

describe 'Project', ->
  makeProject = ->
    new Project
      name: 'my project'
      createdDate: new Date()
      active: true
      postHooks: [1,2,3,4,5]

  it 'should validate a model', ->
    makeProject().validate().should.be.true
