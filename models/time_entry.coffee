BaseModel = require './base'

class TimeEntry extends BaseModel
  constructor: (props) ->
    super props
    @required = ['start', 'end', 'message', 'userId', 'projectId']

    @validator =
      start: ()=>
        (new Date @start).toString() isnt 'Invalid Date'
      end: ()=>
        (new Date @end).toString() isnt 'Invalid Date'

module.exports = TimeEntry

