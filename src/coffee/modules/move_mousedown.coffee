SimplePanorama.modules.move_mousedown = (pano, data) ->
  pano.elem.on 'mousedown', (event) ->
    if event.which is 1
      data.mouseStart = 
        x: event.pageX
        y: event.pageY
      pano.elem.css("cursor", "move")
      event.preventDefault()
  
  $("*").on 'mousemove', (event) ->
    unless data.mouseStart is undefined
      pano.setTargetSpeed((data.mouseStart.x - event.pageX) / $(window).width()*3, 
                         (data.mouseStart.y - event.pageY) / $(window).height()*3)
  
  $("*").on 'mouseup', (event) ->
    if data.mouseStart isnt undefined and event.which is 1
      pano.setTargetSpeed 0
      pano.elem.css("cursor", "auto")
      data.mouseStart = undefined