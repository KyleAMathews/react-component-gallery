React = require 'react/addons'
ComponentGallery = require '../src/index'


module.exports = React.createClass

  getInitialState: ->
    targetWidth: 200
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
      <h2>Demo 1: Straight mode (fixed image ratio)</h2>
      <h3>targetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="slider"
        initialValue={@state.targetWidth}
        onChange={@onWidthChange} />
      <code>{'  '}{@state.targetWidth}px</code>
      <br />
      <br />
      <h3>margin</h3>
      <input
        type="range"
        min=0
        max=50
        ref="margin"
        initialValue={@state.margin}
        onChange={@onMarginChange} />
      <code>{'  '}{@state.margin}px</code>
      <br />
      <br />
      <h3>Components</h3>
      <ComponentGallery
          className="example"
          margin={parseInt(@state.margin, 10)}
          noMarginBottomOnLastRow=true
          widthHeightRatio=3/5
          targetWidth={parseInt(@state.targetWidth, 10)}>
        {children}
      </ComponentGallery>
    </div>

  onWidthChange: (e) ->
    @setState targetWidth: @refs.slider.getDOMNode().value

  onMarginChange: (e) ->
    @setState margin: @refs.margin.getDOMNode().value
