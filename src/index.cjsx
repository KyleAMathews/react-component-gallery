React = require 'react'
componentWidthMixin = require 'react-component-width-mixin'

module.exports = React.createClass
  displayName: "ComponentGallery"
  mixins: [componentWidthMixin]

  propTypes:
    children: React.PropTypes.any.isRequired
    disableServerRender: React.PropTypes.bool

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
      [componentWidth, componentsPerRow] = @calculateComponentWidth()
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

  calculateComponentWidth: ->
    _calcComponentWidth = (adjustComponentsPerRow = 0) =>
      # Calculate the # of components per row to place.
      componentCount = React.Children.count(@props.children)
      componentsPerRow = Math.round(@state.componentWidth/@props.targetWidth)
      componentsPerRow = componentsPerRow - adjustComponentsPerRow

      # There has to be at least one component per row.
      componentsPerRow = Math.max(componentsPerRow, 1)
      if componentsPerRow > componentCount
        componentsPerRow = componentCount

      # Calculate the per-component width with space for in-between
      # components subtracted
      rawWidth = @state.componentWidth / componentsPerRow
      marginRightOffset = ((@props.margin * componentsPerRow) - @props.margin) / componentsPerRow
      componentWidth = rawWidth - marginRightOffset - 0.25

      # Don't get too big.
      maxWidth = if @props.maxWidth? then @props.maxWidth else @props.targetWidth * 1.5
      componentWidth = Math.min(componentWidth, maxWidth)
      return [componentWidth, componentsPerRow, marginRightOffset]

    [componentWidth, componentsPerRow, marginRightOffset] = _calcComponentWidth()

    # If the total margin used in a row is greater than one component, drop the components
    # per row.
    if componentWidth < marginRightOffset * componentsPerRow
      adjustment = Math.round((marginRightOffset*componentsPerRow)/componentWidth)
      [componentWidth, componentsPerRow, marginRightOffset] = _calcComponentWidth(adjustment)

    return [componentWidth, componentsPerRow]
