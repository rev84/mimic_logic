class ImageFile
  @MODE = 
    BASE64: 0
    IMAGE: 1
    CANVAS: 2
  MODE:
    BASE64: 0
    IMAGE: 1
    CANVAS: 2
  constructor:(base64OrImageOrCanvas, mode = @MODE.BASE64)->
    @ctx = null
    switch mode
      when @MODE.BASE64
        @loaded = false
        img = new Image()
        img.onload = (e)=>
          @canvas = document.createElement('canvas')
          [@canvas.width, @canvas.height] = [img.width, img.height]
          @ctx = @canvas.getContext('2d')
          @ctx.drawImage img, 0, 0
          @loaded = true
        img.src = base64OrImageOrCanvas
      when @MODE.IMAGE
        @canvas = document.createElement('canvas')
        [@canvas.width, @canvas.height] = [base64OrImageOrCanvas.width, base64OrImageOrCanvas.height]
        @ctx = @canvas.getContext('2d')
        @ctx.drawImage base64OrImageOrCanvas, 0, 0
        @loaded = true
      when @MODE.CANVAS
        @canvas = base64OrImageOrCanvas
        @ctx = @canvas.getContext('2d')
        @loaded = true

  binarize:(x = 0, y = 0, w = @getWidth(), h = @getHeight(), rgbFilters = [])->
    rgb = @getRgb(x, y, w, h)
    for x in [0...rgb.length]
      for y in [0...rgb[x].length]
        # フィルタ
        filterOk = true
        for rgbFilter in rgbFilters
          filterOk = true
          for key, val of rgbFilter
            if val isnt null
              if val.min? and rgb[x][y][key] < val.min
                filterOk = false
                break
              if val.max? and val.max < rgb[x][y][key]
                filterOk = false
                break
          break if filterOk
        rgb[x][y] = filterOk
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