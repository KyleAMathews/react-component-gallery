React = require 'react/addons'
ComponentGallery = require '../src/index'
{Container} = require 'react-responsive-grid'
StraightGallery = require './straight'
AutoGallery = require './auto'


module.exports = React.createClass

  render: ->
    <Container style={"maxWidth":'1100px'}>
      <h1>react-component-gallery</h1>
      <a href="https://github.com/KyleAMathews/react-component-gallery">Code on Github</a>
      <p>Create a perfect component gallery every time whatever the size of the
      container. Just choose your target width and margin and then the
      component will do the math to figure out how to evenly lay out
      your components.</p>
      <p>Try changing the screen width as well as the targetWidth/margin sliders
      below to see how the component automatically adjusts</p>

      <h2>Example code</h2>
      <pre><code>
      {"""
        <ComponentGallery
          className="example"
          margin=10
          noMarginBottomOnLastRow=true
          widthHeightRatio=3/5
          targetWidth=250
            <img src="https://example.com/pic1.jpg" />
            <img src="https://example.com/pic2.jpg" />
            <img src="https://example.com/pic3.jpg" />
            <img src="https://example.com/pic4.jpg" />
            <img src="https://example.com/pic5.jpg" />
            <img src="https://example.com/pic6.jpg" />
            <img src="https://storage.googleapis.com/relaterocket-logos/nike.com-black@2x.png" />
            <img src="https://storage.googleapis.com/relaterocket-logos/gopro.com-black@2x.png" />
        </ComponentGallery>
        """}
      </code></pre>
      <br />

      <StraightGallery {...@props} />
      <br />

      <AutoGallery {...@props} />

    </Container>
