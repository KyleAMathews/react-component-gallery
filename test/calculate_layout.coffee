chai = require 'chai'
expect = chai.expect

calculateLayout = require '../src/calculate_layout'

describe 'calculateLayout', ->
  it 'should exist', ->
    expect(calculateLayout).to.exist()

  it 'should return an array with two numbers', ->
    result = calculateLayout({
      children: [1,2,3]
      targetWidth: 100
      margin: 10
    }, {
      componentWidth: 500
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)

  it 'should return sane results', ->
    result = calculateLayout({
      children: [1,2,3,4,5,6,7]
      targetWidth: 100
      margin: 10
    }, {
      componentWidth: 500
    })

    expect(result).to.be.instanceOf(Array)
    expect(result).to.have.length(2)
    expect(result[1]).to.equal(5) # Should have 5 components on a row
