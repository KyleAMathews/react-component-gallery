
module.exports = (props) ->
  # Formula is (totalWidth = numComponentsPerRow * componentWidth + ((numComponentsPerRow - 1) * margin))
  # Formula illustrated at:
  # https://docs.google.com/spreadsheets/d/1NDHOtrAY3rvR7LLYaDl7c12Tiao2jEgMzPw9tmT9CRI/edit?usp=sharing

  # Calculate ideal number of components / row
  if props.margin is 0
    idealComponentsPerRow = props.containerWidth / props.targetWidth
  else
    idealComponentsPerRow = ((props.containerWidth/props.margin) + 1) /
      ((props.targetWidth/props.margin) + 1)

  componentsPerRow = Math.round(idealComponentsPerRow)

  childComponentWidth = ((props.containerWidth + props.margin) /
    componentsPerRow) - props.margin

  return [childComponentWidth, componentsPerRow]
