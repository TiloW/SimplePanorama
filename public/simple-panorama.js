(function() {
  window.SimplePanorama = (function() {
    SimplePanorama.modules = {};

    SimplePanorama.use3DTransform = Modernizr.csstransforms3d && (navigator.userAgent.indexOf('Safari') < 0 || navigator.userAgent.indexOf('Chrome') > -1);

    function SimplePanorama(options) {
      var imgFile, pano, wrapperElem;
      this.maxPos = {
        x: 0,
        y: 0
      };
      this.size = {
        x: 0,
        y: 0
      };
      this.elem = null;
      this.img = null;
      this.subElem = null;
      this.pos = {
        x: 0.0,
        y: 0.0
      };
      this.targetSpeed = {
        x: 0,
        y: 0
      };
      this.speed = {
        x: 0,
        y: 0
      };
      this.hsCounter = 0;
      this.isRepeative = null;
      this.moduleData = {};
      this.hotspots = {};
      this.offset = 0;
      this.speedOverride = {
        x: false,
        y: false
      };
      wrapperElem = options.elem;
      if ((!wrapperElem) && options.selector) {
        wrapperElem = $(options.selector);
      }
      if (!wrapperElem.length) {
        throw 'No DOM element supplied for panorama, use "elem" or "selector."';
        return null;
      }
      this.elem = $('<div class="sp-container"></div>');
      imgFile = options.imagePath;
      if (!imgFile) {
        throw 'No image path supplied for panorama, use "imagePath".';
        return null;
      }
      if (options.initialPos) {
        this.pos.x = wrapperElem.innerWidth() / 2 - options.initialPos;
      }
      this.isRepeative = options.repeative === void 0 ? true : options.repeative;
      this.img = new Image;
      pano = this;
      this.img.onload = function() {
        var i, imgHtml, max, _i, _ref;
        pano.elem.css("height", this.height + "px");
        imgHtml = "<div>";
        max = pano.isRepeative ? 2 : 0;
        for (i = _i = 0; 0 <= max ? _i <= max : _i >= max; i = 0 <= max ? ++_i : --_i) {
          imgHtml += "<img class=\"sp-image sp-number_" + i + "\" src=\"" + imgFile + "\" alt\"Panorama\" />";
        }
        pano.elem.html(imgHtml + "</div>");
        pano.subElem = $(pano.elem.children()[0]);
        pano.offset = pano.isRepeative ? this.width : 0;
        pano.subElem.css({
          width: this.width * (max + 1) + "px",
          left: "-" + pano.offset + "px"
        });
        pano.lastTick = (new Date).getTime();
        pano.updateSpeedTicks = 0;
        window.setInterval((function() {
          return pano._updatePano();
        }), 1);
        pano.elem.mousedown(function(event) {
          return event.preventDefault();
        });
        pano.elem.attr("oncontextmenu", "return false;");
        if (options.modules) {
          $.each(options.modules, function(i, moduleId) {
            pano.moduleData[moduleId] = {};
            return SimplePanorama.modules[moduleId](pano, pano.moduleData[moduleId]);
          });
        }
        wrapperElem.html(pano.elem);
        $(window).trigger("resize");
        if ((_ref = options.callback) != null) {
          _ref.call(pano);
        }
        return $(pano).trigger('loaded');
      };
      $(window).resize(function() {
        pano.size.x = pano.img.width < pano.elem.width() ? pano.img.width : pano.elem.parent().innerWidth();
        pano.size.y = pano.img.height < pano.elem.height() ? pano.img.height : pano.elem.parent().innerHeight();
        pano.elem.css("width", pano.width + "px");
        pano.maxPos.x = pano.isRepeative ? pano.img.width : pano.img.width - pano.size.x;
        return pano.maxPos.y = pano.img.height - pano.size.y;
      });
      this.img.src = imgFile;
    }

    SimplePanorama.prototype._updateSpeed = function() {
      if (this.speedOverride.x) {
        this.speed.x = this.speedOverride.x;
        this.speedOverride.x = false;
      } else {
        this.speed.x = (1.8 * this.speed.x + 0.2 * this.targetSpeed.x) / 2;
      }
      if (this.speedOverride.y) {
        this.speed.y = this.speedOverride.y;
        return this.speedOverride.y = false;
      } else {
        return this.speed.y = (1.8 * this.speed.y + 0.2 * this.targetSpeed.y) / 2;
      }
    };

    SimplePanorama.prototype.setCurrentSpeed = function(x, y) {
      if (y == null) {
        y = false;
      }
      if (x) {
        this.speedOverride.x = x;
      }
      if (y) {
        return this.speedOverride.y = y;
      }
    };

    SimplePanorama.prototype.setTargetSpeed = function(x, y) {
      if (y == null) {
        y = 0;
      }
      this.targetSpeed.x = x;
      return this.targetSpeed.y = y;
    };

    SimplePanorama.prototype._boundCoordinate = function(value, max) {
      if (value > 0) {
        return 0;
      } else if (value < -max) {
        return -max;
      } else {
        return value;
      }
    };

    SimplePanorama.prototype._updatePano = function() {
      var newPosX, newPosY, passedTicks, ticks, transform;
      ticks = new Date().getTime();
      passedTicks = ticks - this.lastTick;
      this.lastTick = ticks;
      this.updateSpeedTicks += passedTicks;
      if (this.updateSpeedTicks > 50) {
        this._updateSpeed();
        this.updateSpeedTicks = 0;
      }
      if (this.subElem !== null) {
        newPosX = this.pos.x + this.speed.x * passedTicks;
        newPosY = this.pos.y + this.speed.y * passedTicks;
        this.pos.x = this.isRepeative ? newPosX % this.maxPos.x : this._boundCoordinate(newPosX, this.maxPos.x);
        this.pos.y = this._boundCoordinate(newPosY, this.maxPos.y);
        if (SimplePanorama.use3DTransform) {
          transform = "translate3D(" + this.pos.x + "px, " + this.pos.y + "px, 0)";
          return this.subElem.css({
            "-o-transform": transform,
            "-webkit-transform": transform,
            "-moz-transform": transform,
            "-ms-transform": transform,
            "transform": transform
          });
        } else {
          this.subElem.css("left", this.pos.x - this.offset + "px");
          return this.subElem.css("top", this.pos.y + "px");
        }
      }
    };

    SimplePanorama.prototype.createCircleHotspot = function(content, x, y, r, category) {
      var hs;
      hs = this._prepareHotspot(content, "sp-circ", x - r, y - r, r * 2, r * 2);
      hs.css("border-radius", r + "px");
      this._populateTripleBuffer(hs, category);
      return this.hsCounter;
    };

    SimplePanorama.prototype.createRectHotspot = function(content, x, y, w, h, category) {
      var hs;
      hs = this._prepareHotspot(content, "sp-rect", x, y, w, h);
      this._populateTripleBuffer(hs, category);
      return this.hsCounter;
    };

    SimplePanorama.prototype._prepareHotspot = function(content, cssClass, x, y, w, h) {
      var result;
      result = $('<div class="sp-number-' + ++this.hsCounter + ' sp-hotspot ' + cssClass + '"><div class="sp-hotspot-content">' + content + '</div></div>');
      result.css({
        left: x + 'px',
        top: y + 'px',
        width: w + 'px',
        height: h + 'px'
      });
      return result;
    };

    SimplePanorama.prototype.getRelativePos = function(pageX, pageY) {
      var left, result, top;
      left = this.elem.offset().left;
      top = this.elem.offset().top;
      result = new Object();
      result.x = Math.floor(pageX - left + this.img.width - this.pos.x);
      result.x %= this.img.width;
      result.y = Math.floor(pageY - top);
      if (result.y < 0) {
        result.y = 0;
      }
      return result;
    };

    SimplePanorama.prototype.getRotation = function() {
      return this.getRelativePos(this.elem.offset().left, 0).x;
    };

    SimplePanorama.prototype._populateTripleBuffer = function(elem, category) {
      var c1, c2, left;
      if (!this.hotspots[category]) {
        this.hotspots[category] = [];
      }
      if (this.isRepeative) {
        c1 = elem.clone();
        c2 = elem.clone();
        left = parseInt(elem.css('left').slice(0, -2));
        c1.css("left", left + this.img.width + "px");
        c2.css("left", left + this.img.width * 2 + "px");
        this.subElem.append(c1, c2);
        this.hotspots[category].push(c1, c2);
      }
      this.subElem.append(elem);
      return this.hotspots[category].push(elem);
    };

    SimplePanorama.prototype.showHotspots = function(category, visible) {
      var elem, _i, _len, _ref, _results;
      if (visible == null) {
        visible = true;
      }
      if (this.hotspots[category]) {
        _ref = this.hotspots[category];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          elem = _ref[_i];
          if (visible) {
            _results.push($(elem).show());
          } else {
            _results.push($(elem).hide());
          }
        }
        return _results;
      }
    };

    SimplePanorama.prototype.removeHotspots = function(category) {
      var elem, _i, _len, _ref;
      if (this.hotspots[category]) {
        _ref = this.hotspots[category];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          elem = _ref[_i];
          $(elem).remove();
        }
        return this.hotspots[category] = [];
      }
    };

    return SimplePanorama;

  })();

}).call(this);

(function() {
  SimplePanorama.modules.move_mousedown = function(pano, data) {
    pano.elem.on('mousedown', function(event) {
      if (event.which === 1) {
        data.mouseStart = {
          x: event.pageX,
          y: event.pageY
        };
        pano.elem.css("cursor", "move");
        return event.preventDefault();
      }
    });
    $("*").on('mousemove', function(event) {
      if (data.mouseStart !== void 0) {
        return pano.setTargetSpeed((data.mouseStart.x - event.pageX) / $(window).width() * 3, (data.mouseStart.y - event.pageY) / $(window).height() * 3);
      }
    });
    return $("*").on('mouseup', function(event) {
      if (data.mouseStart !== void 0 && event.which === 1) {
        pano.setTargetSpeed(0);
        pano.elem.css("cursor", "auto");
        return data.mouseStart = void 0;
      }
    });
  };

}).call(this);

(function() {
  SimplePanorama.modules.move_mousehover = function() {
    return function(pano) {
      return pano.elem.on('mousemove', function(event) {
        var setZero;
        pano.setTargetSpeed(2 - (event.pageX - pano.elem.position().left) / pano.elem.width() * 4);
        setZero = pano.targetSpeed.x > 0 ? pano.targetSpeed.x < 1 : pano.targetSpeed.x > -1;
        if (setZero) {
          return pano.setTargetSpeed(0);
        }
      });
    };
  };

}).call(this);

(function() {
  SimplePanorama.modules.move_swipe = function(pano, data) {
    pano.elem.on("touchstart", function(event) {
      data.touchStart = {
        x: event.originalEvent.touches[0].pageX,
        y: event.originalEvent.touches[0].pageY
      };
      return pano.setTargetSpeed(0);
    });
    $("*").on("touchmove", function(event) {
      var speed, tmp;
      if (data.touchStart !== void 0) {
        tmp = {
          x: event.originalEvent.changedTouches[0].pageX,
          y: event.originalEvent.changedTouches[0].pageY
        };
        speed = {
          x: (tmp.x - data.touchStart.x) / 100,
          y: (tmp.y - data.touchStart.y) / 100
        };
        if (Math.abs(speed.x) < Math.abs(pano.speed.x)) {
          speed.x = false;
        }
        if (Math.abs(speed.y) < Math.abs(pano.speed.y)) {
          speed.y = false;
        }
        pano.setCurrentSpeed(speed.x, speed.y);
        return data.touchStart = tmp;
      }
    });
    return $("*").on("touchend", function() {
      if (data.touchStart !== void 0) {
        return data.touchStart = void 0;
      }
    });
  };

}).call(this);

(function() {
  SimplePanorama.modules.move_touch = function(pano, data) {
    pano.elem.on("touchstart", function(event) {
      return data.touchStart = {
        x: event.originalEvent.touches[0].pageX,
        y: event.originalEvent.touches[0].pageY
      };
    });
    $("*").on("touchmove", function(event) {
      if (data.touchStart !== void 0) {
        return pano.setTargetSpeed((data.touchStart.x - event.originalEvent.touches[0].pageX) / 200, (data.touchStart.y - event.originalEvent.touches[0].pageY) / 200);
      }
    });
    return $("*").on("touchend", function() {
      if (data.touchStart !== void 0) {
        pano.setTargetSpeed(0);
        return data.touchStart = void 0;
      }
    });
  };

}).call(this);

(function() {
  SimplePanorama.modules.show_coordinates = function(pano) {
    var box, circ, cursor, postFix, rect, updateCoords;
    box = $('<div class="scInfoBox"><p></p><p></p><p></p></div>');
    cursor = {};
    circ = {};
    rect = {};
    postFix = "SCTemp_9012457832451";
    updateCoords = function() {
      $(box.children('p')[0]).html('Cursor: ' + cursor.x + " " + cursor.y + "<br />Rotation: " + pano.getRotation());
      if (rect.path) {
        $(box.children('p')[1]).html("Rechteck: " + rect.path);
        rect = {};
      }
      if (circ.path) {
        $(box.children('p')[2]).html("Kreis: " + circ.path);
        return circ = {};
      }
    };
    $(pano).on('loaded', function() {
      box.insertBefore(pano.elem);
      return setInterval(updateCoords, 1000 / 30);
    });
    pano.elem.on('mousedown', function(event) {
      switch (event.which) {
        case 3:
          return rect.start = cursor;
        case 2:
          return circ.pos = cursor;
      }
    });
    $("*").on('mouseup', function(event) {
      switch (event.which) {
        case 3:
          return rect.path = rect.x + "," + rect.y + "," + (rect.x + rect.w) + "," + (rect.y + rect.h);
        case 2:
          return circ.path = circ.pos.x + "," + circ.pos.y + "," + circ.r;
      }
    });
    $("*").on('contextmenu', function() {
      return !(rect.start || circ.pos);
    });
    return $("*").on('mousemove', function(event) {
      cursor = pano.getRelativePos(event.pageX, event.pageY);
      if (rect.start) {
        rect.w = Math.abs(cursor.x - rect.start.x);
        rect.h = Math.abs(cursor.y - rect.start.y);
        rect.x = Math.min(cursor.x, rect.start.x);
        rect.y = Math.min(cursor.y, rect.start.y);
        pano.removeHotspots("rect" + postFix);
        pano.createRectHotspot("", rect.x, rect.y, rect.w, rect.h, "rect" + postFix);
      }
      if (circ.pos) {
        circ.r = Math.max(Math.abs(circ.pos.x - cursor.x), Math.abs(circ.pos.y - cursor.y));
        pano.removeHotspots("circ" + postFix);
        return pano.createCircleHotspot("", circ.pos.x, circ.pos.y, circ.r, "circ" + postFix);
      }
    });
  };

}).call(this);
