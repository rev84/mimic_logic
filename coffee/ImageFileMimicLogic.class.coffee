class ImageFileMimicLogic extends ImageFile
  # 一致率を取得
  getMatchRate:(imageFileMimicLogic)->
    # 横幅が合わない
    return 0 unless imageFileMimicLogic.getWidth()-1 <= @getWidth() <= imageFileMimicLogic.getWidth()+1
    # 縦幅が合わない
    return 0 unless imageFileMimicLogic.getHeight()-1 <= @getHeight() <= imageFileMimicLogic.getHeight()+1
    # 検索
    aBinary = imageFileMimicLogic.getMyBinarizeCond()
    bBinary = @getMyBinarizeCond()
    score = 0
    for x in [0...aBinary.length]
      for y in [0...aBinary[x].length]
        continue unless bBinary[x]? and bBinary[x][y]?
        score++ unless aBinary[x][y] ^ bBinary[x][y]
    score / (imageFileMimicLogic.getWidth() * imageFileMimicLogic.getHeight())

  # 枠線を探す2値化をキャッシュ
  getMyBinarizeBorder:->
    unless @myBinarizeBorder?
      @myBinarizeBorder = @binarize 0, 0, undefined, undefined, [
        {
          r: {min: 190}
          g: {min: 190}
          b: {min: 190}
        }
      ]
    @myBinarizeBorder

  # 条件としての一致の2値化をキャッシュ
  getMyBinarizeCond:->
    unless @myBinarizeCond?
      @myBinarizeCond = @binarize 0, 0, undefined, undefined, [
        # 白文字
        {
          r: {min:150}
          g: {min:150}
          b: {min:150}
        }
        # 赤文字
        {
          r: {min:90}
          g: {max:150}
          b: {max:150}
        }
        # 青文字
        {
          r: {max:150}
          g: {max:150}
          b: {min:90}
        }
      ]
    @myBinarizeCond

  # 吹き出しの左上の座標を取得
  getLeftUpPoint:->
    # 横棒と認識する最低の長さ
    COUNT_MIN = 20
    # 吹き出しの丸い部分の横幅
    MARGIN_WIDTH = 8

    myBinaryBorder = @getMyBinarizeBorder()

    # aryに隣接セルが含まれているか
    inArrayNear = (x, y, ary)->
      for [xAry, yAry] in ary
        return true if x-1 <= xAry <= x+1 and y-1 <= yAry <= y+1
      false

    ############
    # 横棒の検出
    ############
    startPoints = []
    for y in [0...@getHeight()]
      xStart = null
      count = 0
      for x in [0...@getWidth()]
        isWhite = myBinaryBorder[x][y]
        if isWhite
          if xStart is null
            xStart = x
            count = 1
          else
            count++
        else
          if xStart isnt null
            if count >= COUNT_MIN
              startPoints.push [xStart, y, count] unless inArrayNear(xStart, y, startPoints)
          xStart = null
          count = 0
      if count >= COUNT_MIN
        startPoints.push [xStart, y, count] unless inArrayNear(xStart, y, startPoints)
    startPoints.sort (a, b)->
      cond1 = a[1] - b[1]
      return cond1 if cond1 isnt 0
      a[0] - b[0]
    console.log 'startPoints:', startPoints

    # startPointsを2つずつ選んで組をつくる
    results = []
    usedStartPoints = Utl.arrayFill startPoints.length, false
    for baseIndex in [0...startPoints.length]
      [baseX, baseY, baseCount] = startPoints[baseIndex]
      continue if usedStartPoints[baseIndex]
      for targetIndex in [baseIndex+1...startPoints.length]
        [targetX, targetY, targetCount] = startPoints[targetIndex]
        continue if usedStartPoints[targetIndex]
        if baseX-2 <= targetX <= baseX+2 and baseY < targetY
          results.push [baseX-MARGIN_WIDTH, baseY, baseCount+MARGIN_WIDTH*2, targetY - baseY]
          usedStartPoints[baseIndex] = usedStartPoints[targetIndex] = true
          break
    results