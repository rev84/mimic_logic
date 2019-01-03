class ImageFileMimicLogic extends ImageFile
  # ミミックの数を取得
  getMimicNum:(mimicLabelImage, mimicNumImages)->
    SCORE_LIMIT = (mimicLabelImage.getWidth()*mimicLabelImage.getHeight()*255*3)*0.075

    myRgb = @getRgb()
    labelRgb = mimicLabelImage.getRgb()
    scores = []
    # 縦は100ピクセルまで
    for y in [0...100]
      for x in [0...@getWidth()]
        continue if @getWidth() <= x + mimicLabelImage.getWidth()
        score = 0
        for x in [0...labelRgb.length]
          for y in [0...labelRgb[x].length]
            score += Math.abs(myRgb[baseX+x][baseY+y].r - labelRgb[x][y].r)
            score += Math.abs(myRgb[baseX+x][baseY+y].g - labelRgb[x][y].g)
            score += Math.abs(myRgb[baseX+x][baseY+y].b - labelRgb[x][y].b)
            # 行き過ぎなので打ち切り
            if SCORE_LIMIT < score
              score = Number.MAX_SAFE_INTEGER
              break
          # スコアがしきい値以内なので追加
          if score <= SCORE_LIMIT
            scores.push [x, y, score]
    scores.sort((a, b)-> a[2] - b[2])
    

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

  getBase64Binarize:(binary)->
    canvas = document.createElement('canvas')
    ctx = canvas.getContext('2d')
    [canvas.width, canvas.height] = [@getWidth(), @getHeight()]
    ctx.fillStyle = '#aaaaaa'
    ctx.fillRect 0, 0, @getWidth(), @getHeight()
    ctx.fillStyle = '#000000'
    
    for x in [0...binary.length]
      for y in [0...binary[x].length]
        ctx.fillRect x, y, 1, 1 if binary[x][y]

    canvas.toDataURL()

  getBase64BinarizeBorder:->
    @getBase64Binarize @getMyBinarizeBorder()

  getBase64BinarizeCond:->
    @getBase64Binarize @getMyBinarizeCond()

  # 枠線を探す2値化をキャッシュ
  getMyBinarizeBorder:->
    unless @myBinarizeBorder?
      @myBinarizeBorder = @binarize 0, 0, undefined, undefined, [
        {
          r: {min: 190}
          g: {min: 190}
          b: {min: 190
          }
        }
      ]
    @myBinarizeBorder

  # 条件としての一致の2値化をキャッシュ
  getMyBinarizeCond:->
    unless @myBinarizeCond?
      @myBinarizeCond = @binarize 0, 0, undefined, undefined, [
        # 白文字
        {
          r: {min:75}
          g: {min:75}
          b: {min:75}
        }
        # 赤文字
        {
          r: {min:90}
          g: {max:150}
          b: {max:150}
        }
        # 青文字
        {
          r: {max:100}
          g: {max:200}
          b: {min:90}
        }
      ]
    @myBinarizeCond

  # 宝箱の位置検出
  getTreasureboxPoints:(treasureboxImageFiles)->
    baseRgb = @getRgb()
    treasureboxes = []
    scores = []
    #scores = Utl.array2dFill baseRgb.length, baseRgb[0].length, 0
    for key, imageFile of treasureboxImageFiles
      SCORE_LIMIT = (imageFile.getWidth()*imageFile.getHeight()*255*3)*0.075 # このスコア以上行った時点で探索打ち切り

      rgb = imageFile.getRgb()
      for baseX in [0...baseRgb.length]
        continue if baseRgb.length <= baseX + imageFile.getWidth()
        for baseY in [0...baseRgb[baseX].length]
          continue if baseRgb[baseX].length <= baseY + imageFile.getHeight()
          score = 0
          for x in [0...rgb.length]
            for y in [0...rgb[x].length]
              score += Math.abs(baseRgb[baseX+x][baseY+y].r - rgb[x][y].r)
              score += Math.abs(baseRgb[baseX+x][baseY+y].g - rgb[x][y].g)
              score += Math.abs(baseRgb[baseX+x][baseY+y].b - rgb[x][y].b)
            # 行き過ぎなので打ち切り
            if SCORE_LIMIT < score
              score = Number.MAX_SAFE_INTEGER
              break
          # スコアがしきい値以内なので追加
          if score <= SCORE_LIMIT
            scores.push [baseX, baseY, window.COLORS[key], score]
            #console.log 'SCORE_LIMIT:',SCORE_LIMIT
          #scores[baseX][baseY] = [baseX, baseY, key, score]

    # このソートでindexに対応
    scores.sort (a, b)->
      y = a[1] - b[1]
      return y if y isnt 0
      a[0] - b[0]

    # フィールドの横・縦幅を取得
    xs = []
    ys = []
    for [x, y, color, score] in scores
      xs.push x unless Utl.inArray x, xs
      ys.push y unless Utl.inArray y, ys
    wField = xs.length
    hField = ys.length
    console.log 'scores:', scores
    [scores, wField, hField]

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
    #console.log 'startPoints:', startPoints

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
          results.push {
            x:baseX-MARGIN_WIDTH
            y:baseY
            w:baseCount+MARGIN_WIDTH*2
            h:targetY - baseY
            index: 0
          }
          usedStartPoints[baseIndex] = usedStartPoints[targetIndex] = true
          break

    # 宝箱の位置検出
    [treasurePoints, wField, hField] = @getTreasureboxPoints(window.TREASUREBOX_IMAGE_FILES)
    # 宝箱の情報から、吹き出しのインデックスを特定
    decidedIndexes = Utl.arrayFill results.length, false
    for [treasureX, treasureY, colorId], treasureIndex in treasurePoints
      nearScores = []
      nearScores[decidedIndex] = {index: decidedIndex, score: Number.MAX_SAFE_INTEGER} for decidedIndex in [0...decidedIndexes.length]
      for isDecided, resultIndex in decidedIndexes
        # もう決定済み
        continue if isDecided
        # 宝箱より右や下の吹き出しはありえない
        continue if treasureX < results[resultIndex].x or treasureY < results[resultIndex].y
        nearScores[resultIndex].score = Math.abs(treasureX - results[resultIndex].x) + Math.abs(treasureY - results[resultIndex].y)
      # ソートして一番距離が短いもの
      nearScores.sort((a, b)-> a.score - b.score)
      # これが対応する吹き出しのインデックス
      nearestIndex = nearScores[0].index
      results[nearestIndex].index = treasureIndex
      results[nearestIndex].color = colorId
      decidedIndexes[nearestIndex] = true

    # 確定したインデックス順に並べ替える
    results.sort((a, b)-> a.index - b.index)

    [results, wField, hField]