React = require 'react'
PropTypes = React.PropTypes
componentWidthMixin = require 'react-component-width-mixin'

calculateLayout = require './calculate_layout'

module.exports = React.createClass
  displayName: "ComponentGallery"
  mixins: [componentWidthMixin]

  propTypes:
    children: PropTypes.any.isRequired
    disableServerRender: PropTypes.bool
    margin: PropTypes.number
    targetWidth: PropTypes.number
    widthHeightRatio: PropTypes.number
    disableServerRender: PropTypes.bool

  getDefaultProps: ->
    margin: 10
    targetWidth: 200
    widthHeightRatio: 1
    disableServerRender: false

  render: ->
    # If we don't know the component width, there's nothing we can do.
    if @state.componentWidth is 0
      <div />
    # If we're server rendering and the user has disabled server rendering.
    else if not @isMounted() and @props.disableServerRender
      <div />
    else
      [componentWidth, componentsPerRow] = calculateLayout(@props, @state)
      return (
        <div className="component-gallery #{@props.className}" style={{overflow: "hidden"}}>
          {React.Children.map(@props.children, (child, i) =>
            if componentsPerRow is 1
              marginRight = 0
            else if i isnt 0 and (i + 1) % componentsPerRow is 0
              marginRight = 0
            else
              marginRight = @props.margin

            return (
              React.DOM.div({
                className: "component-wrapper"
                style: {
                  width: "#{componentWidth}px"
                  height: "#{componentWidth*@props.widthHeightRatio}px"
                  display: "inline-block"
                  marginRight: "#{marginRight}px"
                  marginBottom: "#{@props.margin}px"
                  overflow: "hidden"
                  position: "relative"
                  "verticalAlign": "top"
                }
              }, child)
            )
          )}
        </div>
      )
