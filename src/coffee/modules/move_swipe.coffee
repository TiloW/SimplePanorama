SimplePanorama.modules.move_swipe = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    
    data.touchStart = 
      x: event.originalEvent.touches[0].pageX
      y: event.originalEvent.touches[0].pageY
    pano.doTargetSpeed 0, 0

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      tmp =
        x: event.originalEvent.changedTouches[0].pageX
        y: event.originalEvent.changedTouches[0].pageY
      speed = 
        x: (tmp.x - data.touchStart.x) / 100
        y: (tmp.y - data.touchStart.y) / 100
      
      pano.setSpeedX(speed.x) if Math.abs(speed.x) > Math.abs(pano.speed.x)
      pano.setSpeedY(speed.y) if Math.abs(speed.y) > Math.abs(pano.speed.y)
        
      data.touchStart = tmp
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      data.touchStart = undefined
      

# 
# SimplePanorama.modules.move_swipe = (pano, data) ->
# 
  # pano.elem.on "touchstart", (event) ->
    # pano.setSpeed 0.000001
    # data.touchStart = event.originalEvent.touches[0].pageX
    # pano.doTargetSpeed 0
# 
  # $("*").on "touchmove", (event) ->
    # unless data.touchStart is undefined
      # tmp = event.originalEvent.changedTouches[0].pageX
      # speed = (tmp - data.touchStart) / 100
      # if Math.abs(speed) > Math.abs(pano.speed.x)
        # pano.setSpeed(speed)
      # data.touchStart = tmp
#   
  # $("*").on "touchend", ->
    # unless data.touchStart is undefined
      # data.touchStart = undefined