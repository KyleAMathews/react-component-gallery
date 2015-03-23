React = require 'react/addons'
ComponentGallery = require '../src/index'


module.exports = React.createClass

  getInitialState: ->
    minTargetWidth: 100
    maxTargetWidth: 200
    margin: 10
    children: []

  componentDidMount: ->
    _this = this

    if not window.google
      comnsole.warn 'Google API is not available'
      return

    google.load 'search', 1, {"language" : "en"}

    searchCallback = ->
      searchResponse = this
      searchResults = searchResponse.results || []
      components = searchResults.map (item) ->
        <img src={item.url}/>

      if components.length
        _this.setState {children: components}

    onLoad = ->
      s = new google.search.ImageSearch()
      s.setResultSetSize google.search.Search.LARGE_RESULTSET
      s.setSearchCompleteCallback s, searchCallback
      s.setNoHtmlGeneration
      s.execute 'images portraits'

    google.setOnLoadCallback onLoad

  render: ->
    children = @state.children

    <div>
      <h2>Demo 2: Auto mode (auto fitting)</h2>
      <h3>minTargetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="sliderMin"
        value={@state.minTargetWidth}
        onChange={@onMinTargetWidthChange} />
      <code>{'  '}{@state.minTargetWidth}px</code>
      <br />
      <h3>maxTargetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="sliderMax"
        value={@state.maxTargetWidth}
        onChange={@onMaxTargetWidthChange} />
      <code>{'  '}{@state.maxTargetWidth}px</code>
      <br />
      <h3>margin</h3>
      <input
        type="range"
        min=0
        max=50
        ref="margin"
        value={@state.margin}
        onChange={@onMarginChange} />
      <code>{'  '}{@state.margin}px</code>
      <br />
      <br />
      <h3>Components</h3>
      <ComponentGallery
          mode="auto"
          className="example"
          margin={parseInt(@state.margin, 10)}
          noMarginBottomOnLastRow=true
          minTargetWidth={parseInt(@state.minTargetWidth, 10)}
          maxTargetWidth={parseInt(@state.maxTargetWidth, 10)}>
        {children}
      </ComponentGallery>
    </div>

  onMaxTargetWidthChange: (e) ->
    minValue = parseInt @refs.sliderMin.getDOMNode().value
    maxValue = parseInt @refs.sliderMax.getDOMNode().value
    state = 
      maxTargetWidth: maxValue
    if maxValue < minValue
      state.minTargetWidth = maxValue
    @setState state


  onMinTargetWidthChange: (e) ->
    minValue = parseInt @refs.sliderMin.getDOMNode().value
    maxValue = parseInt @refs.sliderMax.getDOMNode().value
    state = 
      minTargetWidth: minValue
    if minValue > maxValue
      state.maxTargetWidth = minValue
    @setState state

  onMarginChange: (e) ->
    @setState margin: @refs.margin.getDOMNode().value
