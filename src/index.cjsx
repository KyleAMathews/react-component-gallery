React = require 'react'
PropTypes = React.PropTypes
componentWidthMixin = require 'react-component-width-mixin'
assign = require 'object-assign'

calculateLayout = require './calculate_layout'

module.exports = React.createClass
  displayName: "ComponentGallery"
  mixins: [componentWidthMixin]

  propTypes:
    children: PropTypes.any.isRequired
    disableServerRender: PropTypes.bool
    margin: PropTypes.number
    noMarginBottomOnLastRow: PropTypes.bool
    marginBottom: PropTypes.number
    targetWidth: PropTypes.number
    widthHeightRatio: PropTypes.number
    galleryStyle: PropTypes.object
    componentStyle: PropTypes.object

  getDefaultProps: ->
    margin: 10
    noMarginBottomOnLastRow: false
    targetWidth: 200
    widthHeightRatio: 1
    disableServerRender: false
    galleryStyle: {}
    componentStyle: {}

  render: ->
    # If we don't know the component width, there's nothing we can do.
    if @state.componentWidth is 0
      <div />
    # If we're server rendering and the user has disabled server rendering.
    else if @props.disableServerRender
      <div />
    else
      [componentWidth, componentsPerRow] = calculateLayout(@props, @state)
      return (
        <div
          className="component-gallery #{@props.className}"
          style={assign(
            {},
            {overflow: "hidden"},
            @props.galleryStyle
          )}
        >
          {React.Children.map(@props.children, (child, i) =>
            marginBottom = @props.margin

            # Disable margin bottom on last row.
            if @props.noMarginBottomOnLastRow
              # Is this component on the last row?
              numRows = Math.ceil(React.Children.count(@props.children) / componentsPerRow)
              if (i + 1) > ((numRows - 1) * componentsPerRow)
                marginBottom = 0

            # Set marginBottom if passed in specifically.
            if @props.marginBottom and marginBottom isnt 0
              marginBottom = @props.marginBottom

            if componentsPerRow is 1
              marginRight = 0
            else if i isnt 0 and (i + 1) % componentsPerRow is 0
              marginRight = 0
            else
              marginRight = @props.margin

            return (
              React.DOM.div({
                className: "component-wrapper"
                style: assign(
                  {},
                  {
                    width: "#{componentWidth}px"
                    height: "#{componentWidth*@props.widthHeightRatio}px"
                    display: "inline-block"
                    marginRight: "#{marginRight}px"
                    marginBottom: "#{marginBottom}px"
                    overflow: "hidden"
                    position: "relative"
                    verticalAlign: "top"
                  },
                  @props.componentStyle
                )
              }, child)
            )
          )}
        </div>
      )
