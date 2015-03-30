React = require 'react/addons'
ComponentGallery = require '../src/index'


module.exports = React.createClass

  getInitialState: ->
    targetWidth: 200
    margin: 10

  render: ->
    children = [
      <div>
        <img src="https://farm1.staticflickr.com/55/148800272_86cffac801_z.jpg" />
        <span style={
          position: "absolute"
          bottom: 0
          width: "100%"
          background: "rgba(0,0,0,0.5)"
          bottom: 0
          left: 0
          "lineHeight": "30px"
          height: "30px"
          padding: "0 10px"
          color: "white"
        }>Sweet label bro</span>
      </div>,
      <p style={margin: 0}>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus neque massa, sagittis at ex a, suscipit facilisis augue. In vitae placerat est. Aliquam mollis orci id arcu condimentum gravida. Nunc sit amet neque sodales, sagittis erat sed, semper massa. Nam quis arcu et ligula vestibulum iaculis non eu velit. Integer at porta mauris, et placerat arcu. Quisque lacinia hendrerit metus vitae ultricies.

      Sed posuere risus ultrices luctus luctus. Ut interdum mi non neque semper placerat id placerat ex. Maecenas gravida et ante sit amet hendrerit. Aliquam non dictum nisl. Nam non luctus enim. Donec eget lobortis lectus. Nam non vehicula sem, quis congue nisi. Praesent suscipit ante non facilisis iaculis. Phasellus suscipit mauris at diam maximus fringilla nec vitae libero.
      </p>,
      <img src="https://farm3.staticflickr.com/2937/14197491985_58036d5b0e_z.jpg"/>,
      <img src="https://farm3.staticflickr.com/2937/14203620719_a0a4d323ef_z.jpg"/>,
      <img src="https://farm6.staticflickr.com/5516/11906727035_b5ccf50dbd_z.jpg"/>,
      <img src="https://farm6.staticflickr.com/5495/11817560513_41b2f225a5_z.jpg"/>,
      <img src="https://farm4.staticflickr.com/3767/10850685734_996f244676_z.jpg"/>,
      <img src="https://storage.googleapis.com/relaterocket-logos/nike.com-black@2x.png"/>,
      <img src="https://storage.googleapis.com/relaterocket-logos/gopro.com-black@2x.png"/>,
    ]

    <div>
      <h2>Demo 1: Straight mode (fixed image ratio)</h2>
      <h3>targetWidth</h3>
      <input
        type="range"
        min=50
        max=500
        ref="slider"
        value={@state.targetWidth}
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
        value={@state.margin}
        onChange={@onMarginChange} />
      <code>{'  '}{@state.margin}px</code>
      <br />
      <br />
      <h3>Components</h3>
      <ComponentGallery
          className="example"
          mode="straight"
          margin={parseInt(@state.margin, 10)}
          noMarginBottomOnLastRow=true
          targetWidth={parseInt(@state.targetWidth, 10)}
          widthHeightRatio={3/5}>
        {children}
      </ComponentGallery>
    </div>

  onWidthChange: (e) ->
    @setState targetWidth: @refs.slider.getDOMNode().value

  onMarginChange: (e) ->
    @setState margin: @refs.margin.getDOMNode().value

