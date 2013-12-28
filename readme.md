# SimplePanorama

[Here](http://tilow.github.com/SimplePanorama/) you can take a look at the script in action.
SimplePanorama is available under the [MIT License](https://github.com/TiloW/SimplePanorama/blob/master/LICENSE).

If you encounter any problems, feel free to send me a [mail](mailto:tilo@wiedera.de)
or create a question on the [wiki](https://github.com/TiloW/SimplePanorama/wiki).
## Purpose

SimplePanorama is a javascript snippet, allowing you to create a cyclindric panorama for your website in no time.
SimplePanorama makes use of CSS 3D Transforms and gracefully falls back to other solutions if unavaibable.

## Requirements

SimplePanorama requires JQuery, it has so far only been tested with version 1.8.3 but it will probably also work with older versions.

## Setup

You need to include [JQuery](http://jquery.com/download/), [simple-panorama.css](https://github.com/TiloW/SimplePanorama/blob/master/public/simple-panorama.css) and [simple-panorama.js](https://github.com/TiloW/SimplePanorama/blob/master/public/simple-panorama.js).

## Usage

Take a look at the [demo section](https://github.com/TiloW/SimplePanorama/tree/master/public/demos)!

### Creating a Panorama
You can create a new panorama after your DOM is loaded.
Here we create a panorama inside of the DOM element with id="myPanoContainer" and choose the image found at "../my_image.jpg".
```javascript
new SimplePanorama({
  'elem':      $('#myPanoContainer'), 
  'imagePath': '../my_image.jpg'
});
```
	
### Basic Animation
You can animate the panorama by setting the "targetSpeed".
```javascript
pano = new SimplePanorama({
  'elem':      $('#myPanoContainer'), 
  'imagePath': '../my_image.jpg'
});
pano.targetSpeed = 0.1
```

### Adding Hotspots
You can add hotspots to a panorama after it has finished loading.
Here we add a circle and a rectangle.
As you can see, we can embed any html-elements inside of the hotspots.
THe circle methods takes html-content, x,y and radius. A rectangle must be provided html-content, left, top, width and height.
```javascript
new SimplePanorama({
  'selector':  '#myPanoContainer', 
  'imagePath': '../my_image.jpg', 
  'callback':  function() {
    this.createCircleHotspot('<p>Hello World!<br />I\'m a <a href="http://de.wikipedia.org/wiki/Circle">circle</a>.</p>', 300, 250, 200);
    this.createRectHotspot('<p>Hello World!<br />I\'m a rectangle.</p>', 750, 150, 200, 200);
  }
});
```	

### Activating Modules
There are certain modules which can be activaded per panorama instance.
Here we add support for moving the panorama by holding down the primary mousebutton.
```javascript
new SimplePanorama({
  'elem': $('#myPanoContainer'), 
  'imagePath': '../my_image.jpg', 
  'modules': ['move_mousedown']
});
```	
For the time beeing theese modules are available:
- **move_mousedown**: Move the panorama around by dragging it
- **move_mousehover**: Move the panorama around by hovering over it
- **move_touch**: Move the panorama around with a touchscreen
- **move_swipe**: Move the panorama around with a touchscreen (different version, just try)

### Options
As you can see, there are some options which can (or must) be provided to the constructor. Here's a complete list:
- **elem**: a JQuery select result, containing your DOM element
- **selector**: a JQuery selector to be used for fetching your DOM element (only used if **elem** is not supplied)
- **imgPath**: the path to your image file
- **callback**: a function to be called after loading the image and initializing the panorama (mostly used to setup hotspots)
- **modules**: an array of modules to be activated for this instance
- **repeative**: set to "false" if you dont want your panorama to be a full 360° shot
- **initialPos**: the intial rotation of the image (e.g. a value of 300 would result in the first 300 pixels to be hidden on the left)

### Styling Hotspots
The panorama consists only of HTML elements, you can style it using CSS.
Theese are the most important CSS classes:
- **sp-hotspot**: a hotspot, you want to set "background" and "border" here
- **sp-rect**: a rectangular hotspot
- **sp-circ**: a circular hotspot
- **sp-hotspot-content**: a wrapper inside of every hotspot, set "color" and "font" here, also you can change the padding if need be

