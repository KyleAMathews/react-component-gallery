React = require 'react'
PropTypes = React.PropTypes
GalleryRow = require './row'


module.exports = React.createClass

  propTypes:
    children: PropTypes.any.isRequired
    margin: PropTypes.number
    noMarginBottomOnLastRow: PropTypes.bool
    marginBottom: PropTypes.number
    maxTargetWidth: PropTypes.number.isRequired
    minTargetWidth: PropTypes.number.isRequired
    containerWidth: PropTypes.number
    className: PropTypes.string
    galleryClassName: PropTypes.string
    rowClassName: PropTypes.string

  getDefaultProps: ->
    margin: 10
    noMarginBottomOnLastRow: false
    maxTargetWidth: 200
    minTargetWidth: 100

  render: ->
    marginRight = @props.margin || 0
    containerWidth = @props.containerWidth || 0
    maxTargetWidth = @props.maxTargetWidth
    minTargetWidth = @props.minTargetWidth
    averageTargetWidth = (maxTargetWidth + minTargetWidth) / 2
    itemsPerRow = Math.round((@props.containerWidth + marginRight) / (averageTargetWidth + marginRight))
    children = @getChildrenAsArray @props.children
    childrenChunks = @makeChunks(children, itemsPerRow)

    <div  className="component-gallery #{@props.galleryClassName || @props.className || ''}"
          style={{overflow: "hidden"}}>
      {childrenChunks.map (items, i) =>
        # margin bottom
        marginBottom = @props.marginBottom || @props.margin
        # Disable margin bottom on last row.
        if @props.noMarginBottomOnLastRow
          # Check whether this component on the last row
          if i is (childrenChunks.length - 1)
            marginBottom = 0

        # row component
        <GalleryRow
              rowClassName={@props.rowClassName}
              rowId={i}
              averageTargetWidth={averageTargetWidth}
              minTargetWidth={minTargetWidth}
              maxTargetWidth={maxTargetWidth}
              marginRight={marginRight}
              marginBottom={marginBottom}
              containerWidth={containerWidth}
              key={i}>      
          {items}
        </GalleryRow>
      }
    </div>

  getChildrenAsArray: (children)->
    result = []
    React.Children.forEach children, (child)->
      result.push child
    return result

  makeChunks: (array, chunkLenght)->
    array = array.slice()
    chunks = []
    chunk = array.splice(0, chunkLenght)
    while chunk.length
      chunks.push(chunk)
      chunk = array.splice(0, chunkLenght)
    return chunks
