React = require 'react'
PropTypes = React.PropTypes
componentWidthMixin = require 'react-component-width-mixin'
StrictGallery = require './strict_mode'
AutoGallery = require './auto_mode'

isServer = not process.browser
STRICT_MODE = "strict"
AUTO_MODE = "auto"


module.exports = React.createClass

  displayName: "ComponentGallery"
  mixins: [componentWidthMixin]

  propTypes:
    mode: PropTypes.string.isRequired
    disableServerRender: PropTypes.bool
    
  getDefaultProps: ->
    mode: "strict"
    disableServerRender: false
    
  render: ->
    # If we don't know the component width, there's nothing we can do.
    if @state.componentWidth is 0
      <div />
    # If we're server rendering and the user has disabled server rendering.
    else if isServer and
              (@props.disableServerRender or @props.mode is AUTO_MODE)
      <div />
    else
      # strict mode
      if @props.mode is STRICT_MODE
        <StrictGallery containerWidth={@state.componentWidth} {...@props} />
      # auto mode
      else if @props.mode is AUTO_MODE
        <AutoGallery containerWidth={@state.componentWidth} {...@props} />
      else
        <div />
