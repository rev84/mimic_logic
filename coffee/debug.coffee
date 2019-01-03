debug = ->
  conds = [810, 920, 920, 710, 1020, 920]
  colors = [1, 1, 1, 1, 1, 1]

  $('#num_x').val(3)
  $('#num_y').val(2)

  reset()

  $('#num_mimic_min').val(1)
  $('#num_mimic_max').val(1)
  $('#num_mad').val(1)
  $('#item_detail_on').prop 'checked', false
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

putCanvas = (w, h)->
  debug_image_paste = document.getElementById('debug_image_paste')
  canvas = document.createElement('canvas')
  [canvas.width, canvas.height] = [w, h]
  debug_image_paste.appendChild(canvas)
  [canvas, canvas.getContext('2d')]
  
parseImageDebug = (base64)->
  img = new ImageFileMimicLogic base64
  callback = ->
    unless img.isLoaded()
      setTimeout callback, 1000
      return
    leftups = img.getLeftUpPoint()
    console.log leftups
    for [x, y, w, h] in leftups
      [canvas, ctx] = putCanvas(w, h)
      ctx.drawImage img.canvas, x, y, w, h, 0, 0, w, h
      imageFile = new ImageFileMimicLogic canvas, ImageFileMimicLogic.MODE.IMAGE
      $('#debug_image_paste').append $('<img>').attr('src', imageFile.getBase64BinarizeCond())
      matchRates = []
      for condIndex, targetImageFile of window.COND2IMAGE_FILE
        continue if targetImageFile is null
        matchRates.push [condIndex, imageFile.getMatchRate targetImageFile]
      matchRates.sort (a, b)-> b[1] - a[1]
      #console.log 'matchRates:', matchRates
      html = '<table class="table table-bordered">'
      for index in [0...5]
        [condIndex, rate] = matchRates[index]
        classes = []
        if rate > 0.995 and index is 0
          classes.push 'confirm'
        html += '<tr class="'+classes.join(' ')+'">'
        html += '<th>'+condId2Text(condIndex)+'</th>'
        html += '<td>'+condIndex+'</td>'
        html += '<td class="right">'+rate+'</td>'
        html += '<td><img src="'+window.COND2IMAGE_FILE[condIndex].getBase64BinarizeCond()+'"></td>' if window.COND2IMAGE_FILE[condIndex]
        html += '</tr>'
      $('#debug_image_paste').append $('<p>').html(html)

    # ないやつを出す
    $('#debug_image_paste').append $('<h2>').html('まだないやつ')
    tb = $('<table>')
    for index, obj of window.COND2IMAGE_FILE
      if obj is null
        tr = $('<tr>')
        tr.append $('<td>').html(index)
        tr.append $('<td>').html(condId2Text index)
        tb.append tr
    $('#debug_image_paste').append tb
    
  setTimeout callback, 1000

