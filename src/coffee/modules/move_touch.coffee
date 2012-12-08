simplePanorama.modules.move_touch = (pano, data) ->
  
  pano.elem.on "touchstart", (event) ->
    event.preventDefault()
    data.touchStart = event.originalEvent.touches[0].pageX

  $("*").on "touchmove", (event) ->
    unless data.touchStart is undefined
      pano.targetSpeed = (data.touchStart - event.originalEvent.touches[0].pageX) / $(window).width() / 2
  
  $("*").on "touchend", ->
    unless data.touchStart is undefined
      pano.targetSpeed = 0
      data.touchStart = undefined