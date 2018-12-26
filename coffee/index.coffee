$().ready ->
  $('#num_x, #num_y').on 'change', reset
  init()


init = ->
  $('#num_x, #num_y').html('')
  for index in [3..8]
    $('#num_x, #num_y').append($('<option>').attr('value', index).html(index))
  $('#num_x, #num_y').val(3)
  reset()

reset = ->
  x = Number $('#num_x').val()
  y = Number $('#num_y').val()

  $('#num_mimic, #num_money, #num_equip, #num_commodity').html('')
  $('#field tbody').html('')
  for yIndex in [0...y]
    tr = $('<tr>')
    for xIndex in [0...x]
      index = yIndex*x+xIndex
      tr.append getTd(index)
      $('#num_mimic, #num_money, #num_equip, #num_commodity').append($('<option>').html(index).attr('value', index))
    $('#field tbody').append tr
  $('#field tbody').find('.selectpicker').selectpicker({
    noneSelectedText: ''
    width: 'fit'
  })
  $('#num_mimic, #num_money, #num_equip, #num_commodity').append($('<option>').html(x*y).attr('value', x*y))
getTd = (index)->
  $('<td>').html($('#cell_sample').html()).addClass('cell center').attr('id', index)
  