simplePanorama.modules.show_coordinates = (pano) ->
  # down = false
  box = $('<div class="scInfoBox"><p></p><p></p><p></p></div>')
  cursor = {}
  circ = {}
  rect = {}
  postFix = "SCTemp_9012457832451"

  updateCoords = ->
    $(box.children('p')[0]).html 'Cursor: ' + cursor.x + " " + cursor.y + "<br />Rotation: " + pano.getRotation()
    if rect.path
      $(box.children('p')[1]).html "Rechteck: " + rect.path
      rect = {}
    if circ.path
      $(box.children('p')[2]).html "Kreis: " + circ.path
      circ = {}
  
  $(pano).on 'loaded', ->
    box.insertBefore pano.elem
    setInterval(updateCoords, 1000/30)
  
  pano.elem.on 'mousedown', (event) ->    
    switch event.which
      when 3
        rect.start = cursor
      when 2
        circ.pos = cursor
  
  $("*").on 'mouseup', (event) ->    
    switch event.which
      when 3
        rect.path = rect.x + "," + rect.y + "," + (rect.x+rect.w) + "," + (rect.y+rect.h)
      when 2
        circ.path = circ.pos.x + "," + circ.pos.y + "," + circ.r
        
  $("*").on 'contextmenu', () ->
    not (rect.start or circ.pos)

  $("*").on 'mousemove', (event) ->
    cursor = pano.getRelativePos(event.pageX, event.pageY)
    
    if rect.start
      rect.w = Math.abs(cursor.x - rect.start.x)
      rect.h = Math.abs(cursor.y - rect.start.y)
      rect.x = Math.min(cursor.x, rect.start.x)
      rect.y = Math.min(cursor.y, rect.start.y)
      pano.removeHotspots("rect" + postFix)
      pano.createRectHotspot("", rect.x, rect.y, rect.w, rect.h, "rect" + postFix)
    if circ.pos
      circ.r = Math.max(Math.abs(circ.pos.x - cursor.x), Math.abs(circ.pos.y - cursor.y))
      pano.removeHotspots("circ" + postFix)
      pano.createCircleHotspot("", circ.pos.x, circ.pos.y, circ.r, "circ" + postFix)
      





