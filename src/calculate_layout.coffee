isArray = require 'isarray'

module.exports = (props, state) ->
  _calcComponentWidth = (adjustComponentsPerRow = 0) ->
    # Count # of children.
    if props.children
      componentCount = if isArray(props.children) then props.children.length else 1
    else
      # No children, return.
      return [0,0]

    # Calculate the # of components per row to place.
    componentsPerRow = Math.round(state.componentWidth/props.targetWidth)
    componentsPerRow = componentsPerRow - adjustComponentsPerRow

    # There has to be at least one component per row.
    componentsPerRow = Math.max(componentsPerRow, 1)
    if componentsPerRow > componentCount
      componentsPerRow = componentCount

    # Calculate the per-component width.
    totalWidthPerComponent = state.componentWidth / componentsPerRow
    averageRightMargin = ((props.margin * (componentsPerRow - 1))) / componentsPerRow
    childComponentWidth = totalWidthPerComponent - averageRightMargin - 0.25

    # Don't get too big.
    maxWidth = if props.maxWidth? then props.maxWidth else props.targetWidth * 1.5
    childComponentWidth = Math.min(childComponentWidth, maxWidth)
    return [childComponentWidth, componentsPerRow, averageRightMargin]

  [childComponentWidth, componentsPerRow, averageRightMargin] = _calcComponentWidth()

  # If the total margin used in a row is greater than one component,
  # drop the number of components per row.
  if childComponentWidth < (averageRightMargin * (componentsPerRow - 1))
    adjustment = Math.ceil((averageRightMargin * (componentsPerRow - 1)) / childComponentWidth / 2)
    [childComponentWidth, componentsPerRow, averageRightMargin] = _calcComponentWidth(adjustment)

  return [childComponentWidth, componentsPerRow]
