_ = require 'underscore'
React = require('react')
ImageGrid = require '../src/index'

module.exports = React.createClass
  getInitialState: ->
    targetWidth: 200
    margin: 10

  render: ->
    <div style={"max-width":'1200px', margin:'0 auto'}>
      <h1>react-image-grid</h1>
      <a href="https://github.com/KyleAMathews/react-image-grid">Code on Github</a>
      <p>Create a perfect image grid every time whatever the size of the
      container. Just choose your target width and margin and then the
      component will do the math to figure out how to evenly lay out
      your images.</p>
      <p>Try changing the screen width as well as the targetWidth/margin sliders
      below to see how the component automatically adjusts</p>

      <h2>Example code</h2>
      <pre><code>
      {"""
        <ImageGrid
          className="photos"
          margin=10
          widthHeightRatio=3/5
          targetWidth=250
            <img src="https://example.com/pic1.jpg" />
            <img src="https://example.com/pic2.jpg" />
            <img src="https://example.com/pic3.jpg" />
            <img src="https://example.com/pic4.jpg" />
            <img src="https://example.com/pic5.jpg" />
            <img src="https://example.com/pic6.jpg" />
        </ImageGrid>
        """}
      </code></pre>
      <br />
      <br />

      <h2>Demo</h2>
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
      <h3>Photos</h3>
      <ImageGrid
        className="photos"
        margin={@state.margin}
        widthHeightRatio=3/5
        targetWidth={@state.targetWidth}>
          <img src="https://farm1.staticflickr.com/55/148800272_86cffac801_z.jpg" />
          <img src="https://farm3.staticflickr.com/2937/14197491985_58036d5b0e_z.jpg" />
          <img src="https://farm3.staticflickr.com/2937/14203620719_a0a4d323ef_z.jpg" />
          <img src="https://farm6.staticflickr.com/5516/11906727035_b5ccf50dbd_z.jpg" />
          <img src="https://farm6.staticflickr.com/5495/11817560513_41b2f225a5_z.jpg" />
          <img src="https://farm4.staticflickr.com/3767/10850685734_996f244676_z.jpg" />
      </ImageGrid>

      <h3>Logos</h3>
      <ImageGrid
        className="logos"
        margin={@state.margin}
        widthHeightRatio=1
        targetWidth={@state.targetWidth}>
          <img src="http://cdn.ycombinator.com/images/startups/Dropbox-974e8cb3.png" />
          <img src="http://cdn.ycombinator.com/images/startups/Disqus-ed2cbd86.png" />
          <img src="http://cdn.ycombinator.com/images/startups/Airbnb-9c9d2e9e.png" />
          <img src="http://cdn.ycombinator.com/images/startups/Stripe-1e55f58f.png" />
          <img src="http://cdn.ycombinator.com/images/startups/Hipmunk-33969dcc.png" />
          <img src="http://cdn.ycombinator.com/images/startups/Codecademy-89676d22.png" />
      </ImageGrid>

    </div>

  onWidthChange: (e) ->
    @setState targetWidth: @refs.slider.getDOMNode().value

  onMarginChange: (e) ->
    @setState margin: @refs.margin.getDOMNode().value
