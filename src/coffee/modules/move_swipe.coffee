SimplePanorama.modules.move_swipe = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    
    data.touchStart = 
      x: event.originalEvent.touches[0].pageX
      y: event.originalEvent.touches[0].pageY
    pano.setTargetSpeed 0

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      tmp =
        x: event.originalEvent.changedTouches[0].pageX
        y: event.originalEvent.changedTouches[0].pageY
      speed = 
        x: (tmp.x - data.touchStart.x) / 100
        y: (tmp.y - data.touchStart.y) / 100
      
      speed.x = false if Math.abs(speed.x) < Math.abs(pano.speed.x)
      speed.y = false if Math.abs(speed.y) < Math.abs(pano.speed.y)
      pano.setCurrentSpeed(speed.x, speed.y)
        
      data.touchStart = tmp
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      data.touchStart = undefined