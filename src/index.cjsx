React = require 'react'
componentWidthMixin = require 'react-component-width-mixin'

module.exports = React.createClass
  displayName: "ImageGrid"
  mixins: [componentWidthMixin]

  propTypes:
    children: React.PropTypes.any.isRequired

  getInitialState: ->
    width: 0

  getDefaultProps: ->
    margin: 10
    targetWidth: 200
    widthHeightRatio: 1

  render: ->
    if @state.componentWidth isnt 0
      [imageWidth, imagesPerRow] = @calculateImageWidth()
      return (
        <div className="image-grid #{@props.className}" style={{overflow: "hidden"}}>
          {React.Children.map(@props.children, (child, i) =>
            if imagesPerRow is 1
              marginRight = 0
            else if i isnt 0 and (i + 1) % imagesPerRow is 0
              marginRight = 0
            else
              marginRight = @props.margin

            return (
              React.DOM.div({
                className: "image-wrapper"
                style: {
                  width: "#{imageWidth}px"
                  height: "#{imageWidth*@props.widthHeightRatio}px"
                  display: "inline-block"
                  "margin-right": "#{marginRight}px"
                  "margin-bottom": "#{@props.margin}px"
                  overflow: "hidden"
                  position: "relative"
                  "vertical-align": "top"
                }
              }, child)
            )
          )}
        </div>
      )
    else
      <div />

  calculateImageWidth: ->
    _calcImageWidth = (adjustImagesPerRow = 0) =>
      # Calculate the # of images per row to place.
      imageCount = React.Children.count(@props.children)
      imagesPerRow = Math.round(@state.componentWidth/@props.targetWidth)
      imagesPerRow = imagesPerRow - adjustImagesPerRow

      # There has to be at least one image per row.
      imagesPerRow = Math.max(imagesPerRow, 1)
      if imagesPerRow > imageCount
        imagesPerRow = imageCount

      # Calculate the per-image width with space for in-between
      # images subtracted
      rawWidth = @state.componentWidth / imagesPerRow
      marginRightOffset = ((@props.margin * imagesPerRow) - @props.margin) / imagesPerRow
      imageWidth = rawWidth - marginRightOffset - 0.25

      # Don't get too big.
      maxWidth = if @props.maxWidth? then @props.maxWidth else @props.targetWidth * 1.5
      imageWidth = Math.min(imageWidth, maxWidth)
      return [imageWidth, imagesPerRow, marginRightOffset]

    [imageWidth, imagesPerRow, marginRightOffset] = _calcImageWidth()

    # If the total margin used in a row is greater than one image, drop the images
    # per row.
    if imageWidth < marginRightOffset * imagesPerRow
      adjustment = Math.round((marginRightOffset*imagesPerRow)/imageWidth)
      [imageWidth, imagesPerRow, marginRightOffset] = _calcImageWidth(adjustment)

    return [imageWidth, imagesPerRow]
