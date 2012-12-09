// Generated by CoffeeScript 1.4.0
(function() {

  simplePanorama.modules.move_mousedown = function(pano, data) {
    pano.elem.on('mousedown', function(event) {
      if (event.which === 1) {
        data.mouseStart = event.pageX;
        $("html").css("cursor", "move");
        return event.preventDefault();
      }
    });
    $("*").on('mousemove', function(event) {
      if (data.mouseStart !== void 0) {
        return pano.targetSpeed = (data.mouseStart - event.pageX) / $(window).width() * 3;
      }
    });
    return $("*").on('mouseup', function() {
      pano.targetSpeed = 0;
      $("html").css("cursor", "auto");
      return data.mouseStart = void 0;
    });
  };

  simplePanorama.modules.move_mousehover = function() {
    return function(pano) {
      return pano.elem.on('mousemove', function(event) {
        var setZero;
        pano.targetSpeed = 2 - (event.pageX - pano.elem.position().left) / pano.elem.width() * 4;
        setZero = pano.targetSpeed > 0 ? pano.targetSpeed < 1 : pano.targetSpeed > -1;
        if (setZero) {
          return pano.targetSpeed = 0;
        }
      });
    };
  };

  simplePanorama.modules.move_touch = function(pano, data) {
    pano.elem.on("touchstart", function(event) {
      event.preventDefault();
      return data.touchStart = event.originalEvent.touches[0].pageX;
    });
    $("*").on("touchmove", function(event) {
      if (data.touchStart !== void 0) {
        return pano.targetSpeed = (data.touchStart - event.originalEvent.touches[0].pageX) / $(window).width() / 2;
      }
    });
    return $("*").on("touchend", function() {
      if (data.touchStart !== void 0) {
        pano.targetSpeed = 0;
        return data.touchStart = void 0;
      }
    });
  };

}).call(this);
