chai = require 'chai'
expect = chai.expect

calculateLayout = require '../src/strict_calculate_layout'

describe 'strictCalculateLayout', ->
  it 'should exist', ->
    expect(calculateLayout).to.exist()

  it 'should return an array with two numbers', ->
    result = calculateLayout({
      children: [1,2,3]
      targetWidth: 100
      margin: 10
      containerWidth: 500      
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)

  it 'should return sane results', ->
    result = calculateLayout({
      children: [1,2,3,4,5,6,7]
      targetWidth: 100
      margin: 10
      containerWidth: 500
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)
    expect(result[1]).to.equal(5) # Should have 5 components on a row

  it 'should handle small widths with large margins gracefully', ->
    result = calculateLayout({
      children: [1,2,3,4]
      targetWidth: 125
      margin: 80
      containerWidth: 480
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)
    expect(result[1]).to.equal(3)

  it 'should handle very small margins', ->
    result = calculateLayout({
      children: [1,2,3,4]
      targetWidth: 125
      margin: 0.1
      containerWidth: 480
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)
    expect(result[1]).to.equal(4)

  it 'should handle margins of 0', ->
    result = calculateLayout({
      children: [1,2,3,4]
      targetWidth: 125
      margin: 0
      containerWidth: 480
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)
    expect(result[1]).to.equal(4)
