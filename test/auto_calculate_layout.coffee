calculateLayout = require '../src/auto_calculate_layout'
chai = require 'chai'
chaiThings = require 'chai-things'
chai.use(chaiThings);
expect = chai.expect
assert = chai.assert
should = chai.should()


# Tested format 
#
# - Parameters:
#     data: [{width: 100, height: 200}, {width: 100, height: 100}, ...]
#     containerWidth: 1000
#     marginRight: 10
#     mainComponentIdx: 5
# - Returns:
#     sizes = 
#       widthArray: [10,20,30,40, ...]
#       height: 100

# small size images
mockDataByGroups = 
  small: [
    {
      # 14 items
      data: [
        {width: 68, height: 30},
        {width: 68, height: 35},
        {width: 68, height: 40},
        {width: 68, height: 45},
        {width: 68, height: 50},
        {width: 68, height: 55},
        {width: 68, height: 60},
        {width: 68, height: 65},
        {width: 68, height: 70},
        {width: 68, height: 75},
        {width: 68, height: 80},
        {width: 68, height: 90},
        {width: 68, height: 100},
        {width: 68, height: 110},
      ]
      containerWidth: 1000
      marginRight: 10
      mainComponentIdx: 0
      result: null
    }, {
      # 16 items
      data: [
        {width: 68, height: 30},
        {width: 68, height: 35},
        {width: 68, height: 40},
        {width: 68, height: 45},
        {width: 68, height: 50},
        {width: 68, height: 55},
        {width: 68, height: 60},
        {width: 68, height: 65},
        {width: 68, height: 70},
        {width: 68, height: 75},
        {width: 68, height: 80},
        {width: 68, height: 90},
        {width: 68, height: 100},
        {width: 68, height: 110},
        {width: 68, height: 120},
        {width: 68, height: 130},
      ]
      containerWidth: 1000
      marginRight: 0
      mainComponentIdx: 0
      result: null
    }
  ]

  # medium size images
  medium: [
    {
      # 5 items
      data: [
        {width: 198, height: 50},
        {width: 198, height: 100},
        {width: 198, height: 150},
        {width: 198, height: 200},
        {width: 198, height: 250},
      ]
      containerWidth: 1000
      marginRight: 10
      mainComponentIdx: 0
      result: null
    }, {
      # 6 items
      data: [
        {width: 198, height: 50},
        {width: 198, height: 100},
        {width: 198, height: 150},
        {width: 198, height: 200},
        {width: 198, height: 250},
        {width: 198, height: 300},
      ]
      containerWidth: 1000
      marginRight: 0
      mainComponentIdx: 0
      result: null
    },
  ]

  # large size images
  large: [
    {
      # 3 items
      data: [
        {width: 332, height: 200},
        {width: 332, height: 350},
        {width: 332, height: 550},
      ]
      containerWidth: 1000
      marginRight: 10
      mainComponentIdx: 0
      result: null
    }, {
      # 3 items
      data: [
        {width: 332, height: 200},
        {width: 332, height: 350},
        {width: 332, height: 550},
      ]
      containerWidth: 1000
      marginRight: 0
      mainComponentIdx: 0
      result: null
    }
  ]


DELTA = 0.2


testItem = (mockItem, size) ->
  {data, containerWidth, marginRight, result} = mockItem

  it 'should return object in appropriate format', ->
    result.should.be.instanceOf(Object)
    result.should.include.keys(['widthArray', 'height']);
    result.widthArray.should.be.an.instanceOf(Array)
    result.widthArray.should.all.be.above(0)
    result.height.should.be.a('number')
    result.height.should.be.above(0)

  it 'results must meet algorithm checks', ->
    length = result.widthArray.length
    allComponentsWidth = result.widthArray.reduce (acc, width) -> acc + width
    if marginRight > 0
      allComponentsWidth += (marginRight * (result.widthArray.length - 1))

    result.widthArray.should.have.length(data.length)
    assert DELTA > (containerWidth - allComponentsWidth) > 0, 'result is wrong and inconsistent with input data'


describe 'autoCalculateLayout', ->
  it 'should exist', ->
    expect(calculateLayout).to.exist()

  for size, mockGroup of mockDataByGroups

    describe "#{size} size images", ->
      for item in mockGroup
        {data, containerWidth, marginRight, mainComponentIdx} = item
        item.result = calculateLayout(data, containerWidth, marginRight, mainComponentIdx)

        describe "with right margin #{marginRight}px", ->
          testItem item, size
