class ImageFileMimicLogic extends ImageFile
  # 左上の座標を取得
  getLeftUpPoint:->
    RGB_MIN =
      R:200
      G:200
      B:200
    COUNT_MIN = 20

    binary = @binarize(0, 0, undefined, undefined, RGB_MIN.R, RGB_MIN.G, RGB_MIN.B)
    console.log binary
    res = []
    for y in [0...@getHeight()]
      xStart = null
      count = 0
      for x in [0...@getWidth()]
        isWhite = binary[x][y]
        if isWhite
          if xStart is null
            xStart = x
            count = 1
          else
            count++
        else
          if xStart isnt null
            if count >= COUNT_MIN
              res.push [xStart, y, count]
          xStart = null
          count = 0
      if count >= COUNT_MIN
        res.push [xStart, y, count]
    res