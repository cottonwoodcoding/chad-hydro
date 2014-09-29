$ ->

  toggleCatStuff = ->
    $('#cat-accordion').on 'hidden.bs.collapse', ->
      $('.cat-right').removeClass('hide')
      $('.cat-down').addClass('hide')
    $('#cat-accordion').on 'shown.bs.collapse', ->
      $('.cat-right').addClass('hide')
      $('.cat-down').removeClass('hide')

    $('#sub-accordion').on 'hidden.bs.collapse', ->
      $('.sub-right').removeClass('hide')
      $('.sub-down').addClass('hide')
    $('#sub-accordion').on 'shown.bs.collapse', ->
      $('.sub-right').addClass('hide')
      $('.sub-down').removeClass('hide')

  toggleCatStuff()

  search_term = location.search.split('=')
  if search_term.length > 1
    $('#search_term').val(search_term[1].replace('+', ' '))

  $("#list").click (event) ->
    event.preventDefault()
    $("#products .item").addClass "list-group-item"

  $("#grid").click (event) ->
    event.preventDefault()
    $("#products .item").removeClass "list-group-item"
    $("#products .item").addClass "grid-group-item"

  $('.body-container').dotdotdot
      ellipsis: '...',
      wrap: 'word',
      row: 5,
      after: 'a.readmore'

  $('.product-title').dotdotdot
    ellipsis: '...',
    wrap: 'word',
    row: 1

  $('.body-container').each ->
    truncated = $(@).triggerHandler('isTruncated')
    $(@).children().children('.readmore').removeClass('hidden') if truncated

  $('.add_to_cart').click (e) ->
    e.preventDefault()
    $addToCartModal = $('#add_to_cart_modal')
    $addToCartModal.modal('show')
    $addToCartModal.find('.modal-product-title').html($(e.target).attr('value'))
    $('#modal_add_to_cart').attr('href', $(e.target).attr('href'))

  $('#sub-accordion').show ->
    $('#collapse-cat').collapse 'hide'




