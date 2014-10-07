react-component-gallery
================

React component for creating an evenly spaced gallery of child components.

These components can be anything from text, images, a card UI, etc.

You choose a `targetWidth`, `margin`, and `widthHeightRatio` for your components and then this component does the
math to figure out how to size each component. Listens for when its width
changes and re-renders.

## Install
`npm install react-component-gallery`

## Usage

      <ComponentGallery
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
      </ComponentGallery>

If you'll be rendering this component on the server, you'll also want to
pass in a `initialComponentWidth` prop so the component has a width to
calculate against. Otherwise the component will return an empty <div />.
For example, if your rendering for a mobile screen, do something like
`initialComponentWidth=375`

## Demo
http://kyleamathews.github.io/react-component-gallery/
