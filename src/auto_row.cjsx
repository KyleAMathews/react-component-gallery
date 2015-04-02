React = require 'react'
PropTypes = React.PropTypes
equal = require 'deep-equal'
calculate_layout = require './auto_calculate_layout'


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
    rowId: PropTypes.number.isRequired

  getInitialState: ->
    widthArray: @getFilledArray @props.children.length, @props.averageTargetWidth  # array of children width
    height: "auto"          # height of children (one value for all children)
    visibility: "hidden"    # row visibility, become hidden when fitting in progress

  componentDidMount: ->
    # try to fit
    @fitChildren()

  componentWillReceiveProps: (nextProps)->
    width = nextProps.averageTargetWidth * nextProps.children.length +
        nextProps.marginRight * (nextProps.children.length - 1)

    if (Math.abs(width - nextProps.containerWidth) >= nextProps.averageTargetWidth and 
         (@props.minTargetWidth isnt nextProps.minTargetWidth or
            @props.maxTargetWidth isnt nextProps.maxTargetWidth or
              @props.averageTargetWidth isnt nextProps.averageTargetWidth)) or
                @props.averageTargetWidth < nextProps.minTargetWidth or
                  @props.averageTargetWidth > nextProps.maxTargetWidth or
                    @props.marginRight isnt nextProps.marginRight or
                      @props.children.length isnt nextProps.children.length or
                        not equal @props.children, nextProps.children
      newState =
        widthArray:
          @getFilledArray nextProps.children.length, nextProps.averageTargetWidth
        height: "auto"
        visibility: "hidden"
      @setState newState
    
  componentDidUpdate: (prevProps, prevState) ->
    # try to fit
    if @state.visibility is "hidden"
      @fitChildren()

  render: ->
    {widthArray, height, visibility} = @state
    children = @props.children

    # row component
    <div  className="component-row #{@props.rowClassName || ''}"
          style={{
            marginBottom: "#{@props.marginBottom || 0}px"
            overflow: "hidden"
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

        # row item component
        <div  className={"component-wrapper"}
              onLoad={@_on_load_handler}
              onError={@_on_error_handler}
              style={
                display: "inline-block"
                width: "#{widthArray[i] || @props.averageTargetWidth}px"
                height: if isFinite height then "#{height}px" else height
                marginRight: "#{marginRight}px"
                overflow: "hidden"
                position: "relative"
                verticalAlign: "top"
              }
              ref={"component-#{@props.rowId}.#{i}"}
              key={i}>
          { child }
        </div>
      }
    </div>

  _on_load_handler: (event)->
    image = event.target
    image._loaded = true
    @fitChildren()

  _on_error_handler: (event)->
    # mark every failed element
    component = event.currentTarget
    component.width = "100px"
    component.height = "100px"
    image = event.target
    image._loaded = true
    @fitChildren()

  fitChildren: ->
    # if row has no multimedia children - fit it right now    
    if (@hasNoMultimediaElements @getDOMNode()) or
          (@isAllChildrenLoaded @getDOMNode())
      newState = @_calculate_layout()
      newState.visibility = 'visible'
      @setState newState

  # method returns components sizes in the following format:
  #   sizes = 
  #     widthArray: [10,20,30,40, ...]
  #     height: 100
  _calculate_layout: ->
    children = @props.children
    length = children.length
    marginRight = @props.marginRight
    containerWidth = @props.containerWidth
    averageTargetWidth = @props.averageTargetWidth

    # if number of children is to small
    # _width = maxTargetWidth * length + marginRight * (length - 1)     # alternative     
    _width = averageTargetWidth * length + marginRight * (length - 1)   # this one works better
    if length is 1
      containerWidth = averageTargetWidth
    else if Math.abs(_width - containerWidth) > averageTargetWidth
      containerWidth = _width

    # children components data for following calculations
    data = children.map (child, i) =>
      wrapper = @refs["component-#{@props.rowId}.#{i}"].getDOMNode()
      child = wrapper.children[0]
      width: parseInt wrapper.offsetWidth
      height: parseInt child.offsetHeight

    # calculate result
    calculate_layout data, containerWidth, marginRight
    
  getFilledArray: (length, value) ->
    array = []
    i = length
    while i > 0
      array.push value
      i--
    array

  hasNoMultimediaElements: (element) ->
    not (@getMultimediaElements element).length

  getMultimediaElements: (element) ->
    (e for e in element.getElementsByTagName('img'))

  isAllChildrenLoaded: (element) ->
    images = @getMultimediaElements element
    (images.filter(@isImageLoaded).length is images.length)

  isImageLoaded: (element) ->
    reactid = element.getAttribute("data-reactid")
    return (if element._loaded then true else false)
