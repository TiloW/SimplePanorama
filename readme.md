# SimplePanorama


## Purpose

SimplePanorama is some javascript code, allowing you to create a cyclindric panorama for your website in no time.
SimplePanorama makes use of CSS3D transforms and gracefully falls back to other solutions if unavaibable.

## Requirements

SimplePanorama requires JQuery, it has so far only been tested with version 1.8.3 but it will probably also work with older versions.

## Setup

You need to include [JQuery](http://jquery.com/download/), [simple-panorama.css](https://github.com/TiloW/SimplePanorama/blob/master/public/simple-panorama.css) and [simple-panorama.js](https://github.com/TiloW/SimplePanorama/blob/master/public/simple-panorama.js).

## Usage

Take a look at the [demo section](https://github.com/TiloW/SimplePanorama/tree/master/public/demos)!

### Creating a Panorama
You can create a new panorama after your DOM is loaded.
Here we create a panorama inside of the DOM element with id="myPanoContainer" and choose the image found at "../my_image.jpg".

    new SimplePanorama($('#myPanoContainer'), '../my_image.jpg');
	
	
### Basic Animation
You can animate the panorama by setting the "targetSpeed".

    pano = new SimplePanorama($('#myPanoContainer'), '../my_image.jpg');
    pano.targetSpeed = 0.1


### Adding Hotspots
You can add hotspots to a panorama after it has finished loading.
Here we add a circle and a rectangle.
As you can see, we can embed any html-elements inside the hotspots.
A circle must be provided with x,y and radius. A rectangle must be provided with left, top, width and height.

    new SimplePanorama($('#myPanoContainer'), '../my_image.jpg', function() {
        pano.createCircleHotspot('<p>Hello World!<br />I\'m a <a href="http://de.wikipedia.org/wiki/Circle">circle</a>.</p>', 300, 250, 200);
        pano.createRectHotspot('<p>Hello World!<br />I\'m a rectangle.</p>', 750, 150, 200, 200);
    });
	
	
### Activating Modules
There are certain modules which can be activaded per panorama instance.
Here we add support for moving the panorama by holding down the primary mousebutton.

    new SimplePanorama($('#myPanoContainer'), '../my_image.jpg', null, ['move_mousedown']);

For now thoose are the modules available:
- move_mousedown : Move the panorama around by dragging it
- move_mousehover : Move the panorama around by hovering over it
- move_touch : Move the panorama around with a touchscreen