React = require 'react'
PropTypes = React.PropTypes
componentWidthMixin = require 'react-component-width-mixin'
StraightGallery = require './straight'
AutoGallery = require './auto'


module.exports = React.createClass

  displayName: "ComponentGallery"
  mixins: [componentWidthMixin]

  propTypes:
    mode: PropTypes.string.isRequired
    disableServerRender: PropTypes.bool
    
  getDefaultProps: ->
    mode: "sraight"
    disableServerRender: false
    
  render: ->
    # If we don't know the component width, there's nothing we can do.
    if @state.componentWidth is 0
      <div />
    # If we're server rendering and the user has disabled server rendering.
    else if not @isMounted() and @props.disableServerRender
      <div />
    else
      # straight mode
      if @props.mode is "straight"
        <StraightGallery containerWidth={@state.componentWidth} {...@props} />
      # auto mode
      else if @props.mode is "auto"
        <AutoGallery containerWidth={@state.componentWidth} {...@props} />
      else
        <div />
