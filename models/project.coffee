BaseModel = require './base'

class Project extends BaseModel
  constructor: (props) ->
    super props
    @required = ['name', 'createdDate', 'postHooks']

module.exports = Project

