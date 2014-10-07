react-image-grid
================

React component for creating an evenly spaced grid of images.

You choose a `targetWidth`, `margin`, and `widthHeightRatio` for your images and the component does the
math to figure out how to size each image. Re-renders when the component
width changes.

## Install
`npm install react-image-grid`

## Usage

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

If you'll be rendering this component on the server, you'll also want to
pass in a `initialComponentWidth` prop so the component has a width to
calculate against. Otherwise the component will return an empty <div />.
For example, if your rendering for a mobile screen, do something like
`initialComponentWidth=375`

## Demo
http://kyleamathews.github.io/react-image-grid/
