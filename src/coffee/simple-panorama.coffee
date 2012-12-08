window.simplePanorama =
  isTouchDevice: ->
    !!('ontouchstart' in window)

class SimplePanorama

  constructor: (DOMElement, imgFile, execAfterLoad) ->
    @elem = DOMElement
    @subElem = null
    @imgFile = imgFile
    @elem.addClass("sp-container")
    @pos = 0.0
    @targetSpeed = 0
    @speed = 0
    @counter = 0
    @hsCounter = 0
    @noTouchDevice = !simplePanorama.isTouchDevice()
    @moduleData = []
    
    unless Modernizr.csstransforms3d
      @updatePos = ->
        @subElem.css("left", @pos - @img.width + "px")
  
    @img = new Image
    pano = @
    @img.onload = ->
      pano.elem.css("height", @height + "px")
      $(window).trigger("resize")
      
      imgHtml = "<div>"
      for i in [0..2]
        imgHtml += "<img class=\"sp-image sp-number_" + i + "\" src=\"" + imgFile + "\" alt\"Panorama\" />"
      pano.elem.html(imgHtml + "</div>");
      
      width = pano.img.width
      pano.subElem = $(pano.elem.children()[0])
      pano.subElem.css("width", width*3 + "px")
      pano.subElem.css("left", "-" + width + "px")
      
      pano.lastTick = (new Date).getTime()
      pano.updateSpeedTicks = 0
      window.setInterval((-> pano.updatePano()), 1)
      
      if @noTouchDevice
        pano.elem.mousedown -> false
      pano.elem.attr("oncontextmenu", "return false;")
      
      performLoadSpModules(pano)
      execAfterLoad()
  
    $(window).resize ->
      pano.width = if pano.img.width < pano.elem.width() then pano.img.width else pano.elem.parent().innerWidth()
      pano.elem.css("width", pano.width + "px")
    
    @img.src = imgFile
  
  
  updateSpeed: ->
    @speed = (1.7*@speed + 0.3*@targetSpeed)/2
    @pos = @pos % @img.width
  
  updatePano: ->
    ticks = new Date().getTime()
    passedTicks = ticks - @lastTick
    @lastTick = ticks
    @updateSpeedTicks += passedTicks
    
    if @updateSpeedTicks > 50
      @updateSpeed()
      @updateSpeedTicks = 0
    
    unless @subElem is null
      @pos += @speed*passedTicks
      @updatePos()
  
  updatePos: ->
    transform = "translate3D(" + @pos + "px, 0, 0)"
    @subElem.css("-o-transform", transform)
    @subElem.css("-webkit-transform", transform)
    @subElem.css("-moz-transform", transform)
    @subElem.css("-ms-transform", transform)
    @subElem.css("transform", transform)
  
  createCircleHotspot: (content, x, y, r) ->
    hs = @prepareHotspot(content, "sp-circ", x-r, y-r, r, r)
    hs.css("border-radius", r + "px")
    $(hs.children('div')[0]).css("padding", r/4 + "px")
    @populateTripleBuffer(hs)
  
  createRectHotspot: (content, x, y, w, h) ->
    hs = @prepareHotspot(content, "sp-rect", x, y, w, h)
    @populateTripleBuffer(hs)
  
  prepareHotspot: (content, cssClass, x, y, w, h) ->
    if @noTouchDevice
      cssClass += " noTouchDevice"
    @subElem.append('<div class="sp-number-' + ++@hsCounter + ' sp-hotspot ' + cssClass + '"><div>' + content + '<div></div>')
    result = $(".sp-hotspot.sp-number-" + @hsCounter)
    
    result.css("left", x + "px")
    result.css("top", y + "px")
    result.css("width", w + "px")
    result.css("height", h + "px")
    
    result
  
  getRelativePos: (pageX, pageY) ->
    result = new Object()
    result.x = Math.floor(pageX - @elem.offset().left +@img.width - @pos)
    result.x %= @img.width
    result.y = Math.floor(pageY - @elem.offset().top)
    if result.y < 0
      result.y = 0
    result
  
  populateTripleBuffer: (elem) ->
    c1 = elem.clone()
    c2 = elem.clone()
    left = elem.position().left
    c1.css("left", left + @img.width + "px")
    c2.css("left", left + @img.width*2 + "px")
    c1.appendTo(@subElem)
    c2.appendTo(@subElem)
    
    if @noTouchDevice
      animateChildren(elem)
      animateChildren(c1)
      animateChildren(c2)

  animateChildren: (elem) -> 
    children = elem.children()
    children.css("opacity", 0)
    
    elem.mouseenter ->
      children.stop()
      children.animate(opacity: 1, 1500)
    
    elem.mouseleave ->
      children.stop()
      children.css("opacity", 0)
