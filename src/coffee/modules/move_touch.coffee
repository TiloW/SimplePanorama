SimplePanorama.modules.move_touch = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    pano.setSpeed 0.000001
    data.touchStart = event.originalEvent.touches[0].pageX

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      pano.doTargetSpeed((data.touchStart - event.originalEvent.touches[0].pageX) / 200)
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      pano.doTargetSpeed 0
      data.touchStart = undefined