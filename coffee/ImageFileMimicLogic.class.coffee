class ImageFileMimicLogic extends ImageFile
  # 一致率を取得
  getMatchRate:(imageFileMimicLogic)->
    # 横幅が合わない
    return 0 if imageFileMimicLogic.getWidth() isnt @getWidth()
    # 縦幅が合わない
    return 0 if imageFileMimicLogic.getHeight() isnt @getHeight()
    # 検索
    aBinary = imageFileMimicLogic.getMyBinarizeCond()
    bBinary = @getMyBinaryCond()
    score = 0
    for x in [0...aBinary.length]
      for y in [0...aBinary[x].length]
        score++ unless aBinary[x][y] ^ bBinary[x][y]
    score / (@getWidth() * @getHeight())

  # 枠線を探す2値化をキャッシュ
  getMyBinarizeBorder:->
    unless @myBinarizeBorder?
      @myBinarizeBorder = @binarize 0, 0, undefined, undefined, [
        {
          r: {min: 200}
          g: {min: 200}
          b: {min: 200}
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

    # y座標のリストを作る
    yList = []
    for [xStart, y, count], index in startPoints
      yList.push y unless Utl.inArray y, yList
    yList.sort ((a, b)-> a - b)
    console.log 'yList:', yList

    # 上の棒のy座標でフィルタするとともに、縦幅も取得する
    yUpperList = []
    yLengthList = []
    for y, index in yList
      if index % 2 is 0
        yUpperList.push y
      else
        yLengthList.push(y - yUpperList[index // 2])
    console.log 'yUpperList:', yUpperList
    console.log 'yLengthList:', yLengthList

    # 縦の宝箱の数
    yCount = yUpperList.length

    # 各y座標での左端の点を取得
    pastY = null
    xCount = 0
    yCurrent = -1
    leftUpPoints = []
    for [xStart, y, w] in startPoints
      continue unless Utl.inArray y, yUpperList
      if pastY isnt y
        xCount = 0
        pastY = y
        yCurrent++
      h = yLengthList[yCurrent]
      x = xStart - MARGIN_WIDTH # 吹き出しの始まり
      w += MARGIN_WIDTH * 2 # 横棒の長さからマージン2つ分の長さ
      leftUpPoints.push [x, y, w, h]

    console.log 'leftUpPoints:', leftUpPoints
    leftUpPoints
    