React = require 'react'
PropTypes = React.PropTypes


module.exports = React.createClass

  propTypes:
    children: PropTypes.any.isRequired
    averageTargetWidth: PropTypes.number.isRequired
    maxTargetWidth: PropTypes.number.isRequired
    minTargetWidth: PropTypes.number.isRequired
    containerWidth: PropTypes.number.isRequired
    marginRight: PropTypes.number.isRequired
    marginBottom: PropTypes.number.isRequired
    rowClassName: PropTypes.string

  getInitialState: ->
    children: @props.children

  componentWillReceiveProps: (nextProps)->
    @setState {children: @props.children}

  render: ->
    marginBottom = @props.marginBottom || 0
    averageTargetWidth = @props.averageTargetWidth || 0
    children = @state.children

    <div  className="component-row #{@props.rowClassName || ''}"
          style={{
            marginBottom: "#{marginBottom}px"
          }}>

      {React.Children.map(children, (child, i) =>
        
        # margin right
        if children.length is 1
          marginRight = 0
        else if i is children.length - 1
          marginRight = 0
        else
          marginRight = @props.marginRight || 0

        # child styles
        childStyle =
          width: "#{averageTargetWidth}px"
          display: "inline-block"
          marginRight: "#{marginRight}px"
          overflow: "hidden"
          position: "relative"
          verticalAlign: "top"

        <div  className={"component-wrapper"}
              style={childStyle}
              key={i}>
          { child }
        </div>
      )}
    </div>