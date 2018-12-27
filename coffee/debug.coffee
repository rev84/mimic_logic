debug = ->
  conds =  [0, 231, 30, 1440, 50002, 130, 1440, 50001, 0]
  colors =  [3, 1, 1, 1, 3, 3, 2, 2, 1]

  $('#num_x').val(3)
  $('#num_y').val(3)

  reset()

  $('#num_mimic_min').val(1)
  $('#num_mimic_max').val(4)
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
