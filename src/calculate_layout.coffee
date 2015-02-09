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

    # Calculate the per-component width with space for in-between
    # components subtracted
    rawWidth = state.componentWidth / componentsPerRow
    marginRightOffset = ((props.margin * componentsPerRow) - props.margin) / componentsPerRow
    componentWidth = rawWidth - marginRightOffset - 0.25

    # Don't get too big.
    maxWidth = if props.maxWidth? then props.maxWidth else props.targetWidth * 1.5
    componentWidth = Math.min(componentWidth, maxWidth)
    return [componentWidth, componentsPerRow, marginRightOffset]

  [componentWidth, componentsPerRow, marginRightOffset] = _calcComponentWidth()

  # If the total margin used in a row is greater than one component,
  # drop the components per row.
  if componentWidth < marginRightOffset * componentsPerRow
    adjustment = Math.round((marginRightOffset*componentsPerRow)/componentWidth)
    [componentWidth, componentsPerRow, marginRightOffset] = _calcComponentWidth(adjustment)

  return [componentWidth, componentsPerRow]
