react-component-gallery
================

React component for creating an evenly spaced gallery of child components.

These components can be anything from text, images, a card UI, etc.

You choose a `targetWidth`, `margin`, and `widthHeightRatio` for your components and then this component does the
math to figure out how to size each component. Listens for when its width
changes and re-renders.

![screen shot 2014-10-27 at 10 19 40 am](https://cloud.githubusercontent.com/assets/71047/4795569/7a457494-5dfd-11e4-890c-d7e15053c529.png)


## Install
`npm install react-component-gallery`

## Demo
http://kyleamathews.github.io/react-component-gallery/

## Usage

      <ComponentGallery
        className="photos"
        margin=10
        widthHeightRatio=3/5
        targetWidth=250>
          <img src="https://example.com/pic1.jpg" />
          <img src="https://example.com/pic2.jpg" />
          <img src="https://example.com/pic3.jpg" />
          <img src="https://example.com/pic4.jpg" />
          <img src="https://example.com/pic5.jpg" />
          <img src="https://example.com/pic6.jpg" />
      </ComponentGallery>

If you'll be rendering this component on the server, you'll also want to
pass in a `initialComponentWidth` prop so the component has a width to
calculate against. Otherwise the component will return an empty `<div />`.
For example, if you're rendering for a mobile screen, do something like
`initialComponentWidth=375`

## Props

Prop                       |    Description
---------------------------|----------------
`children`                 | Any valid react component
`disableServerRender`      | Renders a empty <div/> on the server
`margin`                   | Set the right and bottom margin for each component. You can set the marginBottom separately if desired.
`noMarginBottomOnLastRow`  | Set marginBottom to 0 for components on the last row. Simplifies styling gallery as a whole.
`marginBottom`             | Set marginBottom (in pixels) separate from marginRight
`targetWidth`              | Desired width for each component. Used when calculating the gallery layout.
`widthHeightRatio`         | Defaults to 1 but useful if components don't fit well in a square.
`galleryStyle`             | Override/set inline styles for the gallery div.
`componentStyle`           | Override/set inline styles for each component div.
