TimeEntry = require '../../models/time_entry'
should = require 'should'

makeT = (offset = 10) ->
  t = new TimeEntry
    start: new Date() - 5
    end: new Date() - offset
    message: 'message goes here'
    userId: 'someuserID'
    projectId: 'someprojectID'

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
    t.message.should.be.equal 'message goes here'
    t.validate().should.be.true

  it 'should not validate', ->
    t = new TimeEntry
      start: 'not a date'
      end: 'not a date either'
      message: 'he he i have invalid dates'
      userId: 'jokster1'
      projectId: 'alternate time continuum'
    t.validate().should.be.false

