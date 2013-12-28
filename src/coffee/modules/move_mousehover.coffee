SimplePanorama.modules.move_mousehover = -> (pano) ->
  pano.elem.on 'mousemove', (event) ->
    pano.targetSpeed = 2 - (event.pageX - pano.elem.position().left) / pano.elem.width()*4
    
    setZero = if pano.targetSpeed > 0 then pano.targetSpeed < 1 else pano.targetSpeed > -1
    if setZero
      pano.targetSpeed = 0
