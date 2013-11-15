TimeEntry = require '../../models/time_entry'
should = require 'should'

makeT = ->
  t = new TimeEntry
    start: new Date() - 5
    end: new Date()
    duration: 60 * 60
    projectId: 10
    message: 'message goes here'

describe 'TimeEntry Model', ->
  it 'should be able to create a new instance', ->
    t = do makeT
    t.should.not.be.equal undefined
  it 'should validate', ->
    t = do makeT
    start = new Date t.start
    end = new Date t.end
    start.should.be.instanceof Date
    end.should.be.instanceof Date
    t.projectId.should.be.equal 10
    t.message.should.be.equal 'message goes here'
    (t.validate).should.be.true

