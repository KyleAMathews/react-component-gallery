React = require 'react'
PropTypes = React.PropTypes


module.exports = React.createClass

  propTypes:
    children: PropTypes.any.isRequired
    targetWidth: PropTypes.number.isRequired
    maxTargetWidth: PropTypes.number.isRequired
    minTargetWidth: PropTypes.number.isRequired
    containerWidth: PropTypes.number.isRequired
    marginRight: PropTypes.number.isRequired
    marginBottom: PropTypes.number.isRequired
    rowClassName: PropTypes.string
    rowId: PropTypes.number.isRequired

  getInitialState: ->
    widthArray: @getFilledArray @props.children.length, @props.targetWidth
    height: "auto"
    visibility: "hidden"

  componentDidMount: ->
    window.setTimeout (=>
      newState = @fitChildren()
      newState.visibility = "visible"
      @setState newState
    ), 1000

  componentWillReceiveProps: (nextProps)->
    if @props.minTargetWidth isnt nextProps.minTargetWidth or
          @props.maxTargetWidth isnt nextProps.maxTargetWidth or
              @props.children.length isnt nextProps.children.length or
                  @props.containerWidth isnt nextProps.containerWidth or
                      @props.marginRight isnt nextProps.marginRight
      newState =
        widthArray:
          @getFilledArray nextProps.children.length, nextProps.targetWidth
        height: "auto"
        visibility: "hidden"
      @setState newState

  componentDidUpdate: (prevProps, prevState) ->
    if @state.visibility is "hidden"
      newState = @fitChildren()
      newState.visibility = "visible"
      @setState newState

  render: ->
    {widthArray, height, visibility} = @state
    children = @props.children

    <div  className="component-row #{@props.rowClassName || ''}"
          style={{
            marginBottom: "#{@props.marginBottom || 0}px"
            visibility: visibility
          }}>

      {children.map (child, i) =>
        
        # margin right
        if children.length is 1
          marginRight = 0
        else if i is children.length - 1
          marginRight = 0
        else
          marginRight = @props.marginRight || 0

        # child styles
        childStyle =
          display: "inline-block"
          width: "#{widthArray[i] || @props.targetWidth}px"
          height: if isFinite height then "#{height}px" else height
          marginRight: "#{marginRight}px"
          overflow: "hidden"
          position: "relative"
          verticalAlign: "top"

        <div  className={"component-wrapper"}
              style={childStyle}
              ref={"component-#{@props.rowId}.#{i}"}
              key={i}>
          { child }
        </div>
      }
    </div>

  # method returns such value:
  #   sizes = 
  #     widthArray: [10,20,30,40, ...]
  #     height: 100
  fitChildren: ->
    children = @props.children
    length = children.length
    allMargins = @props.marginRight * (length - 1)
    usableWidth = @props.containerWidth - allMargins
    result =
      widthArray: []
      height: 0

    if length > 0
      # children components data for following calculations
      mainComponentId = 0
      mainComponentHeight = 0
      data = children.map (child, i) =>
        element = @refs["component-#{@props.rowId}.#{i}"].getDOMNode()
        width = element.offsetWidth
        height = element.offsetHeight
        hasMultimedia = true
        if not element.getElementsByTagName('img').length and
            not element.getElementsByTagName('video').length
          hasMultimedia = false
          if mainComponentHeight < height
            mainComponentId = i
            mainComponentHeight = height

        # data item
        width: width
        height: height
        hasMultimedia: hasMultimedia
        get_k_i: (k) ->  # component modification ratio, this is our target in calculation process
          if mainComponentId is i
            if hasMultimedia
              k
            else
              1
          else
            (k * data[mainComponentId].height / height)

      # now we know everything for calculation - let's finish it
      # first of all find main component ratio      
      if data[mainComponentId].hasMultimedia
        _denominator = data.reduce ((accumulator, item) -> 
          accumulator + (item.width * (data[mainComponentId].height)/item.height)
        ), 0
        K = usableWidth / _denominator
      else
        K = 1
      # result
      result.widthArray = data.map (item) ->
        item.width * item.get_k_i K
      result.height = data[mainComponentId].height * K

    result
    
  getFilledArray: (length, value) ->
    array = []
    i = length
    while i > 0
      array.push value
      i--
    array
