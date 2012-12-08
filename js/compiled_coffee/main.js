// Generated by CoffeeScript 1.4.0

/*
  @depends ../vendor/modernizr.js
  @depends modules.js
*/


(function() {
  var SimplePanorama,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.simplePanorama = {
    isTouchDevice: function() {
      return !!(__indexOf.call(window, 'ontouchstart') >= 0);
    }
  };

  SimplePanorama = (function() {

    function SimplePanorama(DOMElement, imgFile, execAfterLoad) {
      var pano;
      this.elem = DOMElement;
      this.subElem = null;
      this.imgFile = imgFile;
      this.elem.addClass("sp-container");
      this.pos = 0.0;
      this.targetSpeed = 0;
      this.speed = 0;
      this.counter = 0;
      this.hsCounter = 0;
      this.noTouchDevice = !simplePanorama.isTouchDevice();
      this.moduleData = [];
      if (!Modernizr.csstransforms3d) {
        this.updatePos = function() {
          return this.subElem.css("left", this.pos - this.img.width + "px");
        };
      }
      this.img = new Image;
      pano = this;
      this.img.onload = function() {
        var i, imgHtml, width, _i;
        pano.elem.css("height", this.height + "px");
        $(window).trigger("resize");
        imgHtml = "<div>";
        for (i = _i = 0; _i <= 2; i = ++_i) {
          imgHtml += "<img class=\"sp-image sp-number_" + i + "\" src=\"" + imgFile + "\" alt\"Panorama\" />";
        }
        pano.elem.html(imgHtml + "</div>");
        width = pano.img.width;
        pano.subElem = $(pano.elem.children()[0]);
        pano.subElem.css("width", width * 3 + "px");
        pano.subElem.css("left", "-" + width + "px");
        pano.lastTick = (new Date).getTime();
        pano.updateSpeedTicks = 0;
        window.setInterval((function() {
          return pano.updatePano();
        }), 1);
        if (this.noTouchDevice) {
          pano.elem.mousedown(function() {
            return false;
          });
        }
        pano.elem.attr("oncontextmenu", "return false;");
        return execAfterLoad();
      };
      $(window).resize(function() {
        pano.width = pano.img.width < pano.elem.width() ? pano.img.width : pano.elem.parent().innerWidth();
        return pano.elem.css("width", pano.width + "px");
      });
      this.img.src = imgFile;
    }

    SimplePanorama.prototype.updateSpeed = function() {
      this.speed = (1.7 * this.speed + 0.3 * this.targetSpeed) / 2;
      return this.pos = this.pos % this.img.width;
    };

    SimplePanorama.prototype.updatePano = function() {
      var passedTicks, ticks;
      ticks = new Date().getTime();
      passedTicks = ticks - this.lastTick;
      this.lastTick = ticks;
      this.updateSpeedTicks += passedTicks;
      if (this.updateSpeedTicks > 50) {
        this.updateSpeed();
        this.updateSpeedTicks = 0;
      }
      if (this.subElem !== null) {
        this.pos += this.speed * passedTicks;
        return this.updatePos();
      }
    };

    SimplePanorama.prototype.updatePos = function() {
      var transform;
      transform = "translate3D(" + this.pos + "px, 0, 0)";
      this.subElem.css("-o-transform", transform);
      this.subElem.css("-webkit-transform", transform);
      this.subElem.css("-moz-transform", transform);
      this.subElem.css("-ms-transform", transform);
      return this.subElem.css("transform", transform);
    };

    SimplePanorama.prototype.createCircleHotspot = function(content, x, y, r) {
      var hs;
      hs = this.prepareHotspot(content, "sp-circ", x - r, y - r, r, r);
      hs.css("border-radius", r + "px");
      $(hs.children('div')[0]).css("padding", r / 4 + "px");
      return this.populateTripleBuffer(hs);
    };

    SimplePanorama.prototype.createRectHotspot = function(content, x, y, w, h) {
      var hs;
      hs = this.prepareHotspot(content, "sp-rect", x, y, w, h);
      return this.populateTripleBuffer(hs);
    };

    SimplePanorama.prototype.prepareHotspot = function(content, cssClass, x, y, w, h) {
      var result;
      if (this.noTouchDevice) {
        cssClass += " noTouchDevice";
      }
      this.subElem.append('<div class="sp-number-' + ++this.hsCounter + ' sp-hotspot ' + cssClass + '"><div>' + content + '<div></div>');
      result = $(".sp-hotspot.sp-number-" + this.hsCounter);
      result.css("left", x + "px");
      result.css("top", y + "px");
      result.css("width", w + "px");
      result.css("height", h + "px");
      return result;
    };

    SimplePanorama.prototype.getRelativePos = function(pageX, pageY) {
      var result;
      result = new Object();
      result.x = Math.floor(pageX - this.elem.offset().left(+this.img.width - this.pos));
      result.x %= this.img.width;
      result.y = Math.floor(pageY - this.elem.offset().top);
      if (result.y < 0) {
        result.y = 0;
      }
      return result;
    };

    SimplePanorama.prototype.populateTripleBuffer = function(elem) {
      var c1, c2, left;
      c1 = elem.clone();
      c2 = elem.clone();
      left = elem.position().left;
      c1.css("left", left + this.img.width + "px");
      c2.css("left", left + this.img.width * 2 + "px");
      c1.appendTo(this.subElem);
      c2.appendTo(this.subElem);
      if (this.noTouchDevice) {
        animateChildren(elem);
        animateChildren(c1);
        return animateChildren(c2);
      }
    };

    SimplePanorama.prototype.animateChildren = function(elem) {
      var children;
      children = elem.children();
      children.css("opacity", 0);
      elem.mouseenter(function() {
        children.stop();
        return children.animate({
          opacity: 1
        }, 1500);
      });
      return elem.mouseleave(function() {
        children.stop();
        return children.css("opacity", 0);
      });
    };

    return SimplePanorama;

  })();

}).call(this);
