React = require 'react'
PropTypes = React.PropTypes
equal = require 'deep-equal'


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
    if @props.minTargetWidth isnt nextProps.minTargetWidth or
          @props.maxTargetWidth isnt nextProps.maxTargetWidth or
            @props.averageTargetWidth isnt nextProps.averageTargetWidth or
              @props.containerWidth isnt nextProps.containerWidth or
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
          width: "#{widthArray[i] || @props.averageTargetWidth}px"
          height: if isFinite height then "#{height}px" else height
          marginRight: "#{marginRight}px"
          overflow: "hidden"
          position: "relative"
          verticalAlign: "top"

        itemRefName = "component-#{@props.rowId}.#{i}"

        <div  className={"component-wrapper"}
              style={childStyle}
              ref={itemRefName}
              onLoad={@_on_load_handler}
              onError={@_on_error_handler.bind(this, itemRefName)}
              key={i}>
          { child }
        </div>
      }
    </div>

  _on_load_handler: ->
    @fitChildren()

  _on_error_handler: (itemRefName, event)->
    element = this.refs[itemRefName].getDOMNode()
    element.height = "100px"
    element.height = "100px"
    items = @getMultimediaElements element
    items.forEach (item) ->
      item.error = true
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
        width = parseInt element.offsetWidth
        height = parseInt element.offsetHeight
        hasMultimedia = true
        if @hasNoMultimediaElements element
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
      result.widthArray = data.map (item, i) ->
        item.width * item.get_k_i(K)
      result.height = data[mainComponentId].height * K

    result
    
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
    if element.error    # marked as not loaded
      return true
    if not element.complete
      return false
    if element.naturalWidth is 0
      return false
    return true
