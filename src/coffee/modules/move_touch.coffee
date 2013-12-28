SimplePanorama.modules.move_touch = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    data.touchStart = 
      x: event.originalEvent.touches[0].pageX
      y: event.originalEvent.touches[0].pageY

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      pano.doTargetSpeed((data.touchStart.x - event.originalEvent.touches[0].pageX) / 200,
                         (data.touchStart.y - event.originalEvent.touches[0].pageY) / 200)
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      pano.doTargetSpeed 0
      data.touchStart = undefined