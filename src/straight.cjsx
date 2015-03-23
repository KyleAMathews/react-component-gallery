React = require 'react'
PropTypes = React.PropTypes
calculateLayout = require './calculate_layout'


module.exports = React.createClass

  propTypes:
    children: PropTypes.any.isRequired
    disableServerRender: PropTypes.bool
    margin: PropTypes.number
    noMarginBottomOnLastRow: PropTypes.bool
    marginBottom: PropTypes.number
    targetWidth: PropTypes.number
    widthHeightRatio: PropTypes.number

  getDefaultProps: ->
    margin: 10
    noMarginBottomOnLastRow: false
    disableServerRender: false
    widthHeightRatio: 1
    targetWidth: 200
    
  render: ->
    [componentWidth, componentsPerRow] = calculateLayout(@props)
    <div>
      {React.Children.map(@props.children, (child, i) =>
        
        # margin bottom
        marginBottom = @props.marginBottom || @props.margin
        # Disable margin bottom on last row.
        if @props.noMarginBottomOnLastRow
          # Is this component on the last row?
          numRows = Math.ceil(React.Children.count(@props.children) / componentsPerRow)
          if (i + 1) > ((numRows - 1) * componentsPerRow)
            marginBottom = 0
        
        # margin right
        if componentsPerRow is 1
          marginRight = 0
        else if i isnt 0 and (i + 1) % componentsPerRow is 0
          marginRight = 0
        else
          marginRight = @props.margin

        # calculate child styles
        childStyle =
          width: "#{componentWidth}px"
          height: "#{componentWidth*@props.widthHeightRatio}px"
          display: "inline-block"
          marginRight: "#{marginRight}px"
          marginBottom: "#{marginBottom}px"
          overflow: "hidden"
          position: "relative"
          verticalAlign: "top"

        <div  className={"component-wrapper"}
              style={childStyle}>
          { child }
        </div>
      )}
    </div>
