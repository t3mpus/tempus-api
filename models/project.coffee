_ = require 'underscore'

class Project
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

    @required = ['name', 'createdDate', 'postHooks']

  validate: ->
    _.every @required, (property) =>
      typeof @[property] isnt 'undefined'

module.exports = Project

