isArray = require 'isarray'

module.exports = (props, state) ->
  # Formula is (totalWidth = numComponentsPerRow * componentWidth + ((numComponentsPerRow - 1) * margin))
  # Formula illustrated at:
  # https://docs.google.com/spreadsheets/d/1NDHOtrAY3rvR7LLYaDl7c12Tiao2jEgMzPw9tmT9CRI/edit?usp=sharing

  # Calculate ideal number of components / row
  if props.margin is 0
    idealComponentsPerRow = state.componentWidth / props.targetWidth
  else
    idealComponentsPerRow = ((state.componentWidth/props.margin) + 1) /
      ((props.targetWidth/props.margin) + 1)

  componentsPerRow = Math.round(idealComponentsPerRow)

  childComponentWidth = ((state.componentWidth + props.margin) /
    componentsPerRow) - props.margin

  return [childComponentWidth, componentsPerRow]
