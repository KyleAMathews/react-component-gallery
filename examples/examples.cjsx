React = require 'react/addons'
ComponentGallery = require '../src/index'
{Container} = require 'react-responsive-grid'
StrictExample = require './strict_mode'
AutoExample = require './auto_mode'


module.exports = React.createClass

  render: ->
    <Container style={"maxWidth":'1100px'}>
      <h1>react-component-gallery</h1>
      <a href="https://github.com/KyleAMathews/react-component-gallery">Code on Github</a>
      <p>
        Create a perfect component gallery every time whatever the size of the
        container. Just choose your target width and margin and then the
        component will do the math to figure out how to evenly lay out
        your components.
      </p>
      <p>
        Component works in two mainstream modes:
        <ul>
          <li>"strict" - which requires embedded components with strict aspect ratio,</li>
          <li>"auto" - gallery component tries to automatically fit embedded components.</li>
        </ul>
      </p>
      <p>Try changing the screen width as well as the targetWidth/minTargetWidth/maxTargetWidth/margin sliders
      below to see how the component automatically adjusts</p>
      <StrictExample {...@props} />
      <br />
      <AutoExample {...@props} />
    </Container>
