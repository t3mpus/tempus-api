TimeEntry = require '../../models/time_entry'
should = require 'should'

makeT = (offset = 10) ->
  t = new TimeEntry
    start: new Date() - 5
    end: new Date() - offset
    duration: 60 * 60
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
    t.message.should.be.equal 'message goes here'
    t.id.should.have.property 'length', 64
    t.validate().should.be.true

  it 'should gen unique ids for different messages', ->
    t = do makeT
    ta = makeT 100
    t.id.should.not.be.equal ta.id

