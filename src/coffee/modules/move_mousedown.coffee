simplePanorama.modules.move_mousedown = (pano, data) ->
  pano.elem.on 'mousedown', (event) ->
    if event.which is 1
      data.mouseStart = event.pageX
      $("html").css("cursor", "move")
      event.preventDefault()
  
  $("*").on 'mousemove', (event) ->
    unless data.mouseStart is undefined
      pano.targetSpeed = (data.mouseStart - event.pageX) / $(window).width()*3
  
  $("*").on 'mouseup', ->
    pano.targetSpeed = 0
    $("html").css("cursor", "auto")
    data.mouseStart = undefined