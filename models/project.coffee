BaseModel = require './base'
_ = require 'underscore'

class Project extends BaseModel
  constructor: (props) ->
    super props
    @required = ['name', 'createdDate']
    @public = _.clone @required

module.exports = Project

