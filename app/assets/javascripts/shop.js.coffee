$ ->

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

  $('#modal_add_to_cart').click (e) ->
    e.preventDefault()
    href = $(e.target).attr('href')
    quantity = $('#product_quantity').val()
    href = href.replace(href.substring(href.lastIndexOf("/"), href.length), "/#{quantity}")
    $.ajax
      type: 'POST'
      url: href
      success: (data) ->
        window.location.reload()
      error: (data) ->
        window.location.reload()

