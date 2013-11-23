_ = require 'underscore'

class Base
  constructor: (props) ->
    _.each props, (v, k) =>
      @[k] = v

  validate: ->
    _.every @required, (property) =>
      typeof @[property] isnt 'undefined'

module.exports = Base

