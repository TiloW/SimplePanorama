simplePanorama.modules.move_swipe = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    pano.setSpeed 0.000001
    data.touchStart = event.originalEvent.touches[0].pageX
    pano.targetSpeed = 0

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      tmp = event.originalEvent.changedTouches[0].pageX
      speed = (tmp - data.touchStart) / 100
      console.log $(window).width()
      if Math.abs(speed) > Math.abs(pano.speed)
        pano.setSpeed(speed)
      data.touchStart = tmp
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      data.touchStart = undefined