SimplePanorama.modules.move_mousedown = (pano, data) ->
  pano.elem.on 'mousedown', (event) ->
    if event.which is 1
      data.mouseStart = event.pageX
      pano.elem.css("cursor", "move")
      event.preventDefault()
  
  $("*").on 'mousemove', (event) ->
    unless data.mouseStart is undefined
      pano.doTargetSpeed((data.mouseStart - event.pageX) / $(window).width()*3)
  
  $("*").on 'mouseup', (event) ->
    if data.mouseStart isnt undefined and event.which is 1
      pano.doTargetSpeed 0
      pano.elem.css("cursor", "auto")
      data.mouseStart = undefined