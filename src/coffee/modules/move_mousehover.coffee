SimplePanorama.modules.move_mousehover = -> (pano) ->
  pano.elem.on 'mousemove', (event) ->
    pano.doTargetSpeed(2 - (event.pageX - pano.elem.position().left) / pano.elem.width()*4)
    
    setZero = if pano.targetSpeed.x > 0 then pano.targetSpeed.x < 1 else pano.targetSpeed.x > -1
    if setZero
      pano.doTargetSpeed 0
