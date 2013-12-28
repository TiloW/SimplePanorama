class window.SimplePanorama
  @modules: {}

  constructor: (options) ->
    @maxPos = 0
    @width = 0
    @elem = null
    @img = null
    @subElem = null
    @pos = 0.0
    @targetSpeed = 0
    @speed = 0
    @counter = 0
    @hsCounter = 0
    @isRepeative = null
    @moduleData = {}
    @offset = 0
    @hotspots = {}
    
    wrapperElem = options.elem
    if (not wrapperElem) and options.selector
      wrapperElem = $(options.selector)
    unless wrapperElem.length
      throw 'No DOM element supplied for panorama, use "elem" or "selector."'
      return null
      
    @elem = $('<div class="sp-container"></div>')
    
    imgFile = options.imagePath
    unless imgFile
      throw 'No image path supplied for panorama, use "imagePath".'
      return null
      
    if options.initialPos
      @pos = wrapperElem.innerWidth()/2 -options.initialPos
      # @pos = -options.initialPos
     
    @isRepeative =  if options.repeative is undefined then true else options.repeative
  
    @img = new Image
    pano = @
    @img.onload = ->
      pano.elem.css("height", @height + "px")
      
      imgHtml = "<div>"
      max = if pano.isRepeative then 2 else 0
        
      for i in [0..max]
        imgHtml += "<img class=\"sp-image sp-number_" + i + "\" src=\"" + imgFile + "\" alt\"Panorama\" />"
      pano.elem.html(imgHtml + "</div>");
      
      pano.subElem = $(pano.elem.children()[0])
      pano.offset = if pano.isRepeative then @width else 0
      pano.subElem.css
        width: @width*(max+1) + "px"
        left:  "-" + pano.offset + "px"
      
      pano.lastTick = (new Date).getTime()
      pano.updateSpeedTicks = 0
      window.setInterval((-> pano.updatePano()), 1)
      
      pano.elem.on 'touchstart', (event) -> event.preventDefault()
      pano.elem.mousedown (event) -> event.preventDefault()
      pano.elem.attr("oncontextmenu", "return false;")
      
      if options.modules
        $.each options.modules, (i, moduleId) ->
          pano.moduleData[moduleId] = {}
          SimplePanorama.modules[moduleId](pano, pano.moduleData[moduleId])
      
      wrapperElem.html pano.elem
      $(window).trigger("resize")
      
      options.callback?.call(pano)
      $(pano).trigger('loaded')
  
    $(window).resize ->
      pano.width = if pano.img.width < pano.elem.width() then pano.img.width else pano.elem.parent().innerWidth()
      pano.elem.css("width", pano.width + "px")
    
      pano.maxPos = if pano.isRepeative then pano.img.width else pano.img.width - pano.width
      
    @img.src = imgFile
  
  updateSpeed: ->    
    if @speedOverride
      @speed = @speedOverride
      @speedOverride = false
    else
      @speed = (1.8*@speed + 0.2*@targetSpeed)/2
      
  setSpeed: (speed) ->
    @speedOverride = speed
  
  updatePano: ->
    ticks = new Date().getTime()
    passedTicks = ticks - @lastTick
    @lastTick = ticks
    @updateSpeedTicks += passedTicks
    
    if @updateSpeedTicks > 50
      @updateSpeed()
      @updateSpeedTicks = 0
    
    unless @subElem is null
      newPos = @pos + @speed*passedTicks

      if @isRepeative
        newPos = newPos % @maxPos
      else
        if newPos > 0
          newPos = 0
        else if newPos < -@maxPos
          newPos = -@maxPos

      @pos = newPos
        
      if Modernizr.csstransforms3d and navigator.userAgent.indexOf('Safari') < 0
        transform = "translate3D(" +  @pos + "px, 0, 0)"
        @subElem.css
          "-o-transform": transform
          "-webkit-transform": transform
          "-moz-transform": transform
          "-ms-transform": transform
          "transform": transform
      else
        @subElem.css("left", @pos-@offset + "px")
  
  createCircleHotspot: (content, x, y, r, category) ->
    hs = @prepareHotspot(content, "sp-circ", x-r, y-r, r*2, r*2)
    hs.css("border-radius", r + "px")
    @populateTripleBuffer(hs, category)
    @hsCounter
  
  createRectHotspot: (content, x, y, w, h, category) ->
    hs = @prepareHotspot(content, "sp-rect", x, y, w, h)
    @populateTripleBuffer(hs, category)
    @hsCounter
      
  prepareHotspot: (content, cssClass, x, y, w, h) ->
    result = $('<div class="sp-number-' + ++@hsCounter + ' sp-hotspot ' + cssClass + '"><div class="sp-hotspot-content">' + content + '</div></div>')
    
    result.css
      left:   x + 'px'
      top:    y + 'px'
      width:  w + 'px'
      height: h + 'px'
    
    result
  
  getRelativePos: (pageX, pageY) ->
    left = @elem.offset().left
    top = @elem.offset().top
    result = new Object()
    result.x = Math.floor(pageX - left + @img.width - @pos)
    result.x %= @img.width
    result.y = Math.floor(pageY - top)
    if result.y < 0
      result.y = 0
    result
  
  getRotation: ->
    @getRelativePos(@elem.offset().left, 0).x
  
  populateTripleBuffer: (elem, category) ->
    @hotspots[category] = [] unless @hotspots[category]
    
    if @isRepeative
      c1 = elem.clone()
      c2 = elem.clone()
      left = parseInt(elem.css('left')[0..-3])
      c1.css("left", left + @img.width + "px")
      c2.css("left", left + @img.width*2 + "px")
      @subElem.append(c1, c2)
      @hotspots[category].push(c1, c2)

    @subElem.append(elem)
    @hotspots[category].push elem
    
  showHotspots: (category, visible = true) ->
    if @hotspots[category]
      for elem in @hotspots[category]
        if visible
          $(elem).show()
        else
          $(elem).hide()
    
  removeHotspots: (category) ->
    if @hotspots[category]
      for elem in @hotspots[category]
        $(elem).remove()
      @hotspots[category] = []
