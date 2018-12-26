window.CONFIG = 
  FIELD_MIN: 2
  FIELD_MAX: 8

window.CONSTS =
  NOT_MIMIC: 0
  MIMIC: 1
  EQUIP: 2
  MONEY: 3
  COMMODITY: 4

window.COLORS =
  RED: 1
  BLUE: 2
  BLACK: 3

window.DIRECTIONS =
  UP: 1
  DOWN: 2
  LEFT: 3
  RIGHT: 4

window.CONDS = 
  'Zzz...':
    0: 'Zzz...'
  'ミミック同士は縦か横で隣あった位置に':
    1100: 'いる'
    1110: 'いない'
  '上の宝箱は':
    710: 'ミミックだ'
    720: 'ミミックじゃない'
  '下の宝箱は':
    810: 'ミミックだ'
    820: 'ミミックじゃない'
  '左の宝箱は':
    910: 'ミミックだ'
    920: 'ミミックじゃない'
  '右の宝箱は':
    1010: 'ミミックだ'
    1020: 'ミミックじゃない'
  '赤い宝箱の中に':
    10: 'ミミックがいるよ'
    20: 'ミミックはいないよ'
    30: 'ミミックは0匹いる'
    31: 'ミミックは1匹いる'
    32: 'ミミックは2匹いる'
    33: 'ミミックは3匹いる'
    34: 'ミミックは4匹いる'
    35: 'ミミックは5匹いる'
    36: 'ミミックは6匹いる'
    37: 'ミミックは7匹いる'
    38: 'ミミックは8匹いる'
    39: 'ミミックは9匹いる'
  '青い宝箱の中に':
    110: 'ミミックがいるよ'
    120: 'ミミックはいないよ'
    130: 'ミミックは0匹いる'
    131: 'ミミックは1匹いる'
    132: 'ミミックは2匹いる'
    133: 'ミミックは3匹いる'
    134: 'ミミックは4匹いる'
    135: 'ミミックは5匹いる'
    136: 'ミミックは6匹いる'
    137: 'ミミックは7匹いる'
    138: 'ミミックは8匹いる'
    139: 'ミミックは9匹いる'
  '黒い宝箱の中に':
    210: 'ミミックがいるよ'
    220: 'ミミックはいないよ'
    230: 'ミミックは0匹いる'
    231: 'ミミックは1匹いる'
    232: 'ミミックは2匹いる'
    233: 'ミミックは3匹いる'
    234: 'ミミックは4匹いる'
    235: 'ミミックは5匹いる'
    236: 'ミミックは6匹いる'
    237: 'ミミックは7匹いる'
    238: 'ミミックは8匹いる'
    239: 'ミミックは9匹いる'
  '一番上の列に':
    310: 'ミミックがいるよ'
    320: 'ミミックはいないよ'
  '一番下の列に':
    410: 'ミミックがいるよ'
    420: 'ミミックはいないよ'
  '一番左の列に':
    510: 'ミミックがいるよ'
    520: 'ミミックはいないよ'
  '一番右の列に':
    610: 'ミミックがいるよ'
    620: 'ミミックはいないよ'
  '上の列と下の列は':
    1210: '上の方がミミックが多い'
    1220: '下の方がミミックが多い'
  '左の列と右の列は':
    1310: '左の方がミミックが多い'
    1320: '右の方がミミックが多い'
  '赤宝箱と':
    1410: '青宝箱は、赤宝箱の方がミミックが多い'
    1420: '青宝箱は、青宝箱の方がミミックが多い'
    1421: '青宝箱のミミックの数は同じ'
    1430: '黒宝箱は、赤宝箱の方がミミックが多い'
    1440: '黒宝箱は、黒宝箱の方がミミックが多い'
    1441: '黒宝箱のミミックの数は同じ'
  '青宝箱と':
    1510: '赤宝箱は、青宝箱の方がミミックが多い'
    1520: '赤宝箱は、赤宝箱の方がミミックが多い'
    1521: '赤宝箱のミミックの数は同じ'
    1530: '黒宝箱は、青宝箱の方がミミックが多い'
    1540: '黒宝箱は、黒宝箱の方がミミックが多い'
    1541: '黒宝箱のミミックの数は同じ'
  '黒宝箱と':
    1610: '赤宝箱は、黒宝箱の方がミミックが多い'
    1620: '赤宝箱は、赤宝箱の方がミミックが多い'
    1621: '赤宝箱のミミックの数は同じ'
    1630: '青宝箱は、黒宝箱の方がミミックが多い'
    1640: '青宝箱は、青宝箱の方がミミックが多い'
    1641: '青宝箱のミミックの数は同じ'
  '私は':
    1700: 'ミミックじゃない'
window.CACHE =
  TD_HTML: null

$().ready ->
  $('#num_x, #num_y').on 'change', reset
  $('#judge').on 'click', judge
  $('#clear').on 'click', clear
  init()
  debug()

debug = ->
  colors = []
  conds = []

  $('#num_x').val(3)
  $('#num_y').val(3)

  reset()

  $('#num_mimic').val(2)
  $('#num_money').val(0)
  $('#num_equip').val(0)
  $('#num_commodity').val(0)

  for color, index in colors
    $('select.box').eq(index).selectpicker('val', color)

  for cond, index in conds
    $('.cond1').eq(index).val(cond2cond1(cond))

  $('.cond1').each ->
    changeCond2.bind(@)()
  
  for cond, index in conds
    $('.cond2').eq(index).val(cond)

cond2cond1 = (cond)->
  for cond1, obj of window.CONDS
    for id, cond2japanese of obj
      return cond1 if Number(id) is Number(cond)
  null

init = ->
  $('#num_x, #num_y').html('')
  for index in [window.CONFIG.FIELD_MIN..window.CONFIG.FIELD_MAX]
    $('#num_x, #num_y').append($('<option>').attr('value', index).html(index))
  $('#num_x, #num_y').val(2)
  reset()

clear = ->
  numMimic = $('#num_mimic').val()
  reset()
  $('#num_mimic').val(numMimic)

reset = ->
  x = getX()
  y = getY()
  cellNum = getCellNum()

  $('#num_mimic, #num_money, #num_equip, #num_commodity').html('')
  $('#field tbody').html('')
  for yIndex in [0...y]
    tr = $('<tr>')
    for xIndex in [0...x]
      index = yIndex*x+xIndex
      tr.append getTd(index)
      $('#num_mimic, #num_money, #num_equip, #num_commodity').append($('<option>').html(index).attr('value', index))
    $('#field tbody').append tr
  $('#field tbody').find('.box').selectpicker({
    noneSelectedText: ''
    width: 'fit'
  })
  $('#num_mimic, #num_money, #num_equip, #num_commodity').append($('<option>').html(cellNum).attr('value', cellNum))

getTd = (index)->
  if window.CACHE.TD_HTML is null
    window.CACHE.TD_HTML = $('#cell_sample').html()
  td = $('<td>').html(window.CACHE.TD_HTML).addClass('cell center').attr('data-index', index)
  td.find('.cond1, .cond2').html('')
  td.find('.cond1').append $('<option>').html('').attr('value', 0)
  for title, obj of window.CONDS
    td.find('.cond1').append(
      $('<option>').html(title)
    )
  td.find('.cond1').on 'change', changeCond2
  td
  
changeCond2 = ->
  cond1 = $(@).val()
  cond2 = $(@).parent().find('.cond2')
  cond2.html('').append($('<option>').html('').attr('value', 0))
  for condId, text of window.CONDS[cond1]
    cond2.append($('<option>').html(text).attr('value', condId))

judge = ->
  x = getX()
  y = getY()
  cellNum = getCellNum()
  numMimic = getNumMimic()
  numMoney = getNumMoney()
  numEquip = getNumEquip()
  numCommodity = getNumCommodity()

  conds = Utl.arrayFill getCellNum()
  colors = Utl.arrayFill getCellNum()
  [numMimic, numMoney, numEquip, numCommodity] = [getNumMimic(), getNumMoney(), getNumEquip(), getNumCommodity()]
  $('.cell').each ->
    index = Number $(@).attr('data-index')
    box = Number $(@).find('select.box').eq(0).val()
    box = if Utl.inArray(box, [window.COLORS.RED, window.COLORS.BLUE, window.COLORS.BLACK]) then box else window.COLORS.RED
    cond = Number $(@).find('.cond2').eq(0).val()
    conds[index] = cond
    colors[index] = box
  # インデックス一覧
  stockedIndexes = 
    COLOR: getColorIndexes colors # 色ごと
    LINE: getLineIndexes colors, x, y # 列ごと
    NEAR: getNearIndexes colors, x, y # 自身の隣
    COLOR_NEAR: getColorNearIndexes colors, x, y  # 色の隣
  console.log 'conds:', conds
  console.log 'colors:', colors
  console.log 'stockedIndexes', stockedIndexes

  # まずはミミックだけを仮定する
  patterns = genPattern([cellNum - numMimic, numMimic, 0, 0, 0])
  validPatternOnlyMimicResearch = getValidPattern(conds, colors, stockedIndexes, patterns)
  console.log 'validPatternOnlyMimicResearch', validPatternOnlyMimicResearch
  # アイテム種別を考慮する必要がないか、この時点でミミックが確定できていれば終了
  if mustConsiderType(conds) or checkMimic(validPatternOnlyMimicResearch, numMimic)
    return viewTitle validPatternOnlyMimicResearch

  # 確定をのぞいてさらに探索
  numNotMimic = 
    if (cellNum - numMimic) is (numEquip + numMoney + numCommodity)
      0
    else
      numEquip = numMoney = numCommodity = 0
      cellNum - numMimic
  patterns = genPattern([numNotMimic, numMimic, numEquip, numMoney, numCommodity], validPatternOnlyMimicResearch)
  validPattern = getValidPattern(conds, colors, stockedIndexes, patterns)
  console.log 'validPattern', validPattern
  # 全探索したので最終回答
  viewTitle validPattern
  
viewTitle = (views)->
  $('td, .title').removeClass('mimic money equip commodity unknown')
  for typeConsts, index in views
    [className, html] = 
      if typeConsts.length > 1
        if Utl.inArray(window.CONSTS.MIMIC, typeConsts)
          ['unknown', '？']
        else
          ['not_mimic', '宝']
      else
        switch typeConsts[0]
          when window.CONSTS.MIMIC
            ['mimic', 'ミミック']
          when window.CONSTS.NOT_MIMIC
            ['not_mimic', '宝']
          when window.CONSTS.EQUIP
            ['equip', '装備']
          when window.CONSTS.MONEY
            ['money', 'お金']
          when window.CONSTS.COMMODITY
            ['commodity', '消費アイテム']
          else
            ['', '']
    $('.title').eq(index).addClass(className).html(html)
    $('td').eq(index).addClass(className)

# 宝の種別を考慮しないといけないか
mustConsiderType = (conds)->
  false

checkMimic = (validPattern, numMimic)->
  mimic = 0
  for typeConstArray, index in validPattern
    mimic++ if typeConstArray.length is 1 and typeConstArray[0] is window.CONSTS.MIMIC
  console.log 'checkMimic:', mimic is numMimic
  mimic is numMimic


getValidPattern = (conds, colors, stockedIndexes, patterns)->
  valids = []
  for pattern in patterns
    res = isValidPattern(conds, colors, stockedIndexes, pattern)
    valids.push pattern if res
  console.log 'valids', valids

  collects = Utl.arrayFill colors.length, []
  for valid in valids
    for type ,index in valid
      if not Utl.inArray type, collects[index]
        collects[index].push type
  collects

isValidPattern = (conds, colors, stockedIndexes, pattern)->
  console.log(conds, pattern)
  for cond, index in conds
    isMimic = pattern[index] is window.CONSTS.MIMIC
    res = switch cond
      # ある宝箱の隣にミミックがいる
      # 上
      when 710 then isContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.UP], window.CONSTS.MIMIC)
      # 下
      when 810 then isContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.DOWN], window.CONSTS.MIMIC)
      # 左
      when 910 then isContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.LEFT], window.CONSTS.MIMIC)
      # 右
      when 1010 then isContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.RIGHT], window.CONSTS.MIMIC)
      # ある宝箱の隣にミミックがいない
      # 上
      when 720 then isNotContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.UP], window.CONSTS.MIMIC)
      # 下
      when 820 then isNotContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.DOWN], window.CONSTS.MIMIC)
      # 左
      when 920 then isNotContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.LEFT], window.CONSTS.MIMIC)
      # 右
      when 1020 then isNotContainType(pattern, stockedIndexes.NEAR[index][window.DIRECTIONS.RIGHT], window.CONSTS.MIMIC)
      # ある色の宝箱にミミックがいる
      # 赤
      when 10 then isContainType(pattern, stockedIndexes.COLOR[window.COLORS.RED], window.CONSTS.MIMIC)
      # 青
      when 110 then isContainType(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], window.CONSTS.MIMIC)
      # 黒
      when 210 then isContainType(pattern, stockedIndexes.COLOR[window.COLORS.BLACK], window.CONSTS.MIMIC)
      # ある色の宝箱にミミックがn匹いる
      # 赤
      when 30,31,32,33,34,35,36,37,38,39 then isContainTypeCount(pattern, stockedIndexes.COLOR[window.COLORS.RED], window.CONSTS.MIMIC, cond % 30)
      # 青
      when 130,131,132,133,134,135,136,137,138,139 then isContainTypeCount(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], window.CONSTS.MIMIC, cond % 130)
      # 黒
      when 230,231,232,233,234,235,236,237,238,239 then isContainTypeCount(pattern, stockedIndexes.COLOR[window.COLORS.BLACK], window.CONSTS.MIMIC, cond % 230)
      # ある色の宝箱にミミックがいない
      # 赤
      when 20 then isNotContainType(pattern, stockedIndexes.COLOR[window.COLORS.RED], window.CONSTS.MIMIC)
      # 青
      when 120 then isNotContainType(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], window.CONSTS.MIMIC)
      # 黒
      when 220 then isNotContainType(pattern, stockedIndexes.COLOR[window.COLORS.BLACK], window.CONSTS.MIMIC)
      # ある列にミミックがいる
      # 上
      when 310 then isContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.UP], window.CONSTS.MIMIC)
      # 下
      when 410 then isContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.DOWN], window.CONSTS.MIMIC)
      # 左
      when 510 then isContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.LEFT], window.CONSTS.MIMIC)
      # 右
      when 610 then isContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.RIGHT], window.CONSTS.MIMIC)
      # ある列にミミックがいない
      # 上
      when 320 then isNotContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.UP], window.CONSTS.MIMIC)
      # 下
      when 420 then isNotContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.DOWN], window.CONSTS.MIMIC)
      # 左
      when 520 then isNotContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.LEFT], window.CONSTS.MIMIC)
      # 右
      when 620 then isNotContainType(pattern, stockedIndexes.LINE[window.DIRECTIONS.RIGHT], window.CONSTS.MIMIC)
      # ミミック同士は隣り合った位置に
      # いる
      when 1100 then isMimicNearly(pattern, stockedIndexes.NEAR)
      # いない
      when 1110 then not isMimicNearly(pattern, stockedIndexes.NEAR)
      
      # 上の列と下の列は
      # 上の列の方がミミックが多い
      when 1210 then compareIndexes(pattern, stockedIndexes.LINE[window.DIRECTIONS.UP], stockedIndexes.LINE[window.DIRECTIONS.DOWN], -1)
      # 下の列の方がミミックが多い
      when 1220 then compareIndexes(pattern, stockedIndexes.LINE[window.DIRECTIONS.UP], stockedIndexes.LINE[window.DIRECTIONS.DOWN], 1)

      # 左の列と右の列は
      # 左の列の方がミミックが多い
      when 1310 then compareIndexes(pattern, stockedIndexes.LINE[window.DIRECTIONS.LEFT], stockedIndexes.LINE[window.DIRECTIONS.RIGHT], -1)
      # 右の列の方がミミックが多い
      when 1320 then compareIndexes(pattern, stockedIndexes.LINE[window.DIRECTIONS.LEFT], stockedIndexes.LINE[window.DIRECTIONS.RIGHT], 1)

      # 赤宝箱と青宝箱は
      # 赤宝箱の方がミミックが多い
      when 1410, 1520 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLUE], -1)
      # 青宝箱の方がミミックが多い
      when 1420, 1510 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLUE], 1)
      # 同じ
      when 1421, 1521 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLUE], 0)
      # 赤宝箱と黒宝箱は
      # 赤宝箱の方がミミックが多い
      when 1430, 1620 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLACK], -1)
      # 黒宝箱の方がミミックが多い
      when 1440, 1610 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLACK], 1)
      # 同じ
      when 1441, 1621 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.RED], stockedIndexes.COLOR[window.COLORS.BLACK], 0)
      # 青宝箱と黒宝箱は
      # 青宝箱の方がミミックが多い
      when 1530, 1640 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], stockedIndexes.COLOR[window.COLORS.BLACK], -1)
      # 黒宝箱の方がミミックが多い
      when 1540, 1630 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], stockedIndexes.COLOR[window.COLORS.BLACK], 1)
      # 同じ
      when 1541, 1641 then compareIndexes(pattern, stockedIndexes.COLOR[window.COLORS.BLUE], stockedIndexes.COLOR[window.COLORS.BLACK], 0)

      # 私はミミックじゃない
      when 1700 then isNotContainType(pattern, [index], window.CONSTS.MIMIC)

      else (isMimic = false) or true
      
    res = not res if isMimic
    console.log(cond, res)
    return false unless res
  true

# [win]
# 0 : 同じ
# -1: indexes1が多い
# 1 : indexes2が多い
compareIndexes = (pattern, indexes1, indexes2, win)->
  mimic1 = mimic2 = 0
  for index in indexes1
    mimic1++ if pattern[index] is window.CONSTS.MIMIC
  for index in indexes2
    mimic2++ if pattern[index] is window.CONSTS.MIMIC
  # line1が多い
  if win < 0
    mimic1 > mimic2
  # line2が多い
  else if win > 0
    mimic1 < mimic2
  else
    mimic1 is mimic2


# ミミック同士は隣あった位置にいるか
isMimicNearly = (pattern, nearIndexes)->
  mimics = []
  for typeConst, index in pattern
    mimics.push index if typeConst is window.CONSTS.MIMIC
  for index1 in [0...mimics.length]
    for index2 in [index1+1...mimics.length]
      isExist = false
      for key, indexes of nearIndexes[mimics[index1]]
        isExist = true if Utl.inArray(mimics[index2], indexes)
      return false unless isExist
  true

# 指定したインデックスに指定したタイプがいるか
isContainType = (pattern, indexes, typeConst)->
  for index in indexes
    # ミミック以外を指定で、ミミックではない
    return true if typeConst is window.CONSTS.NOT_MIMIC and pattern[index] isnt window.CONSTS.MIMIC
    # タイプ合致
    return true if typeConst is pattern[index]
  false

# 指定したインデックスに指定したタイプがn匹いるか
isContainTypeCount = (pattern, indexes, typeConst, count)->
  nowCount = 0
  for index in indexes
    if typeConst is window.CONSTS.NOT_MIMIC and pattern[index] isnt window.CONSTS.MIMIC
      nowCount++
    else if typeConst is pattern[index]
      nowCount++
      
  count is nowCount

# 指定したインデックスに指定したタイプがいないか
isNotContainType = (pattern, indexes, typeConst)->
  for index in indexes
    # ミミック以外が含まれていないのに、ミミック以外が含まれている
    return false if typeConst is window.CONSTS.NOT_MIMIC and pattern[index] isnt window.CONSTS.MIMIC
    # ミミックが含まれていないのに、ミミックである
    return false if typeConst is window.CONSTS.MIMIC and pattern[index] is window.CONSTS.MIMIC
    # タイプ合致
    return false if typeConst is pattern[index]
  true

# 特定の色の宝箱のインデックス
getColorIndexes = (colors)->
  res = {}
  for name, num of window.COLORS
    res[num] = []
  for color, index in colors
    res[color].push index
  res

# 特定の列のインデックス
getLineIndexes = (colors, x, y)->
  res = {}
  for dirName, dirNum of window.DIRECTIONS
    res[dirNum] = []
  # 上
  res[window.DIRECTIONS.UP].push index for index in [0...x]
  # 下
  res[window.DIRECTIONS.DOWN].push index for index in [x*y-x...x*y]
  # 左
  res[window.DIRECTIONS.LEFT].push index*x for index in [0...y]
  # 右
  res[window.DIRECTIONS.RIGHT].push (index+1)*x-1 for index in [0...y]

  res

# 特定の宝箱の隣接のインデックス
getNearIndexes = (colors, x, y)->
  res = Utl.arrayFill colors.length, {}
  for index in [0...res.length]
    for dirName, dirNum of window.DIRECTIONS
      res[index][dirNum] = []
  for color, index in colors
    # 上
    up = index - x
    res[index][window.DIRECTIONS.UP].push up if 0 <= up < x*y
    # 下
    down = index + x
    res[index][window.DIRECTIONS.DOWN].push down if 0 <= down < x*y
    # 左
    left = index - 1
    res[index][window.DIRECTIONS.LEFT].push left if 0 <= left < x*y and index // x is left // x
    # 右
    right = index + 1
    res[index][window.DIRECTIONS.RIGHT].push right if 0 <= right < x*y and index // x is right // x
  res

# 特定の色の宝箱の隣接のインデックス
getColorNearIndexes = (colors, x, y)->
  res = {}
  for colorName, colorNum of window.COLORS
    res[colorNum] = {}
    for dirName, dirNum of window.DIRECTIONS
      res[colorNum][dirNum] = []
  for color, index in colors
    # 上
    up = index - x
    res[color][window.DIRECTIONS.UP].push up if 0 <= up < x*y
    # 下
    down = index + x
    res[color][window.DIRECTIONS.DOWN].push down if 0 <= down < x*y
    # 左
    left = index - 1
    res[color][window.DIRECTIONS.LEFT].push left if 0 <= left < x*y and index // x is left // x
    # 右
    right = index + 1
    res[color][window.DIRECTIONS.RIGHT].push right if 0 <= right < x*y and index // x is right // x
  res

getX = ->
  Number $('#num_x').val()
getY = ->
  Number $('#num_y').val()
getCellNum = ->
  getX() * getY()
getNumMimic = ->
  Number $('#num_mimic').val()
getNumMoney = ->
  Number $('#num_money').val()
getNumEquip = ->
  Number $('#num_equip').val()
getNumCommodity = ->
  Number $('#num_commodity').val()

# [confirmIndexes]
# indexにあわせて確定のtypeConstが入っている
genPattern = (ary, confirmIndexes = null)->
  # [ミミック以外(オールマイティ), ミミック, 装備, お金, 消費アイテム]
  consts = [window.CONSTS.NOT_MIMIC, window.CONSTS.MIMIC, window.CONSTS.EQUIP, window.CONSTS.MONEY, window.CONSTS.COMMODITY]
  remain = Utl.clone ary
  total = 0
  total += num for num in ary

  if confirmIndexes isnt null
    for constsArray, index in confirmIndexes
      if constsArray.length is 1 and constsArray[0] isnt window.CONSTS.NOT_MIMIC
        ary[constsArray[0]]--

  all = []
  getPatternFunc = (m, remain)->
    if m.length is total
      all.push m
      return true
    for num, index in remain
      continue if num <= 0
      # 該当しないなら飛ばす
      if confirmIndexes isnt null
        condNotMimic = Utl.inArray(window.CONSTS.NOT_MIMIC, confirmIndexes[m.length])
        condEquip = Utl.inArray(window.CONSTS.EQUIP, confirmIndexes[m.length])
        condMoney = Utl.inArray(window.CONSTS.MONEY, confirmIndexes[m.length])
        condCommodity = Utl.inArray(window.CONSTS.COMMODITY, confirmIndexes[m.length])
        if index is window.CONSTS.NOT_MIMIC
          if not condNotMimic and not condEquip and not condMoney and not condCommodity
            continue
        else if Utl.inArray(index, [window.CONSTS.EQUIP, window.CONSTS.MONEY, window.CONSTS.COMMODITY])
          if not condNotMimic and not Utl.inArray(index, confirmIndexes[m.length])
            continue
        else if index is window.CONSTS.MIMIC
          if not Utl.inArray(index, confirmIndexes[m.length])
            continue
      newM = Utl.clone m
      newRemain = Utl.clone remain
      newRemain[index]--
      newM.push consts[index]
      getPatternFunc(newM, newRemain)

  getPatternFunc([], remain)
  console.log '組み合わせ:', all
  all