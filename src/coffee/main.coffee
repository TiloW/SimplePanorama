class window.SimplePanorama
  @modules: {}  # stores all modules available for each SimplePanorama instance
  # whether to use css 3d transformations,
  # 3d transform is gpu-accellerated but produces artifacts in safari
  @use3DTransform: Modernizr.csstransforms3d and (navigator.userAgent.indexOf('Safari') < 0 or navigator.userAgent.indexOf('Chrome') > -1)

  constructor: (options) ->
    @maxPos = {x:0,y:0}      # the maximum valid position
    @size = {x:0,y:0}        # the size of the view
    @elem = null             # the main DOM element, wrapped by jQuery
    @img = null              # the image element
    @subElem = null          # holds the buffered images
    @pos = {x:0.0,y:0.0}     # current position of the panorama
    @targetSpeed = {x:0,y:0} # currently targeted speed
    @speed = {x:0,y:0}       # current speed
    @hsCounter = 0           # counts the hotspots for this instance
    @isRepeative = null      # whether one is able to scroll infinitly
    @moduleData = {}         # holds data for all enabled modules for this instance
    @hotspots = {}           # holds all hotspots for this panorama
    @offset = 0              # x-offset used only for repeative panoramas
    @speedOverride =         # used to set speed to fixed value
      x: false
      y: false

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
      @pos.x = wrapperElem.innerWidth()/2 -options.initialPos
     
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
      pano.size.x = if pano.img.width < pano.elem.width() then pano.img.width else pano.elem.parent().innerWidth()
      pano.size.y = if pano.img.height < pano.elem.height() then pano.img.height else pano.elem.parent().innerHeight()
      pano.elem.css("width", pano.width + "px")
    
      pano.maxPos.x = if pano.isRepeative then pano.img.width else pano.img.width - pano.size.x
      pano.maxPos.y = pano.img.height - pano.size.y
      
    @img.src = imgFile    
  
  updateSpeed: ->
    if @speedOverride.x
      @speed.x = @speedOverride.x
      @speedOverride.x = false
    else
      @speed.x = (1.8*@speed.x + 0.2*@targetSpeed.x)/2
      
    if @speedOverride.y
      @speed.y = @speedOverride.y
      @speedOverride.y = false
    else
      @speed.y = (1.8*@speed.y + 0.2*@targetSpeed.y)/2
      
  setSpeedX: (speed) ->
    @speedOverride.x = speed
    
  setSpeedY: (speed) ->
    @speedOverride.y = speed
      
  doTargetSpeed: (x, y = 0) ->
    @targetSpeed.x = x
    @targetSpeed.y = y
    
  boundCoordinate: (value, max) ->
    if value > 0
      0
    else if value < -max
      -max
    else
      value
    
  updatePano: ->
    ticks = new Date().getTime()
    passedTicks = ticks - @lastTick
    @lastTick = ticks
    @updateSpeedTicks += passedTicks
    
    if @updateSpeedTicks > 50
      @updateSpeed()
      @updateSpeedTicks = 0
    
    unless @subElem is null
      newPosX = @pos.x + @speed.x*passedTicks
      newPosY = @pos.y + @speed.y*passedTicks
      
      @pos.x = if @isRepeative then newPosX % @maxPos.x else @boundCoordinate(newPosX, @maxPos.x)
      @pos.y = @boundCoordinate(newPosY, @maxPos.y)

      if SimplePanorama.use3DTransform
        transform = "translate3D(#{@pos.x}px, #{@pos.y}px, 0)"
        @subElem.css
          "-o-transform": transform
          "-webkit-transform": transform
          "-moz-transform": transform
          "-ms-transform": transform
          "transform": transform
      else
        @subElem.css("left", @pos.x-@offset + "px")
        @subElem.css("top", @pos.y + "px")
  
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
    result.x = Math.floor(pageX - left + @img.width - @pos.x)
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
