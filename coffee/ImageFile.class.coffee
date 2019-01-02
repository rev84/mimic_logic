class ImageFile
  constructor:(base64)->
    @ctx = null
    @loaded = false
    img = new Image()
    img.onload = (e)=>
      @canvas = document.createElement('canvas')
      [@canvas.width, @canvas.height] = [img.width, img.height]
      @ctx = @canvas.getContext('2d')
      @ctx.drawImage img, 0, 0
      @loaded = true
    img.src = base64

  binarize:(x = 0, y = 0, w = @getWidth(), h = @getHeight(), r = null, g = null, b = null)->
    rgb = @getRgb(x, y, w, h)
    for x in [0...rgb.length]
      for y in [0...rgb[x].length]
        rCond = r is null or rgb[x][y].r >= r
        gCond = g is null or rgb[x][y].g >= g
        bCond = b is null or rgb[x][y].b >= b

        rgb[x][y] = rCond and gCond and bCond
        console.log 'binary:', x, y if rCond and gCond and bCond

    rgb

  getRgb:(x = 0, y = 0, w = @getWidth(), h = @getHeight())->
    res = []
    imagedata = @ctx.getImageData(x, y, w, h)
    for val, index in imagedata.data
      dotIndex = Math.floor(index / 4)
      colorIndex = index % 4
      xIndex = dotIndex % w
      yIndex = Math.floor(dotIndex / w)
      res[xIndex] = [] unless res[xIndex]?
      res[xIndex][yIndex] = {} unless res[xIndex][yIndex]?
      switch colorIndex
        when 0
          res[xIndex][yIndex].r = val
        when 1
          res[xIndex][yIndex].g = val
        when 2
          res[xIndex][yIndex].b = val
        when 3
          res[xIndex][yIndex].a = val
    res

  getWidth:->
    @canvas.width
  getHeight:->
    @canvas.height
  isLoaded:->
    @loaded