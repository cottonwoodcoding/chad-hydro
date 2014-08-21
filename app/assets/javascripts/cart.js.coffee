$ ->
  $('#modal_add_to_cart').click (e) ->
    e.preventDefault()
    href = $(e.target).attr('href')
    quantity = $('#product_quantity').val()
    href = href.replace(href.substring(href.lastIndexOf("/"), href.length), "/#{quantity}")
    $.ajax
      type: 'POST'
      url: href
      success: (data) ->
        console.log data
        window.location.reload()
      error: (data) ->
        responseText = data.responseText
        if responseText == '/users/sign_in'
          window.location.href = responseText
        else
          window.location.reload()

  $('.remove_from_cart').click (e) ->
    e.preventDefault()
    $removeFromCartModal = $('#remove_from_cart_modal')
    $removeFromCartModal.modal('show')
    $('#modal_remove_from_cart').attr('href', $(e.target).attr('href'))

  $('#modal_remove_from_cart').click (e) ->
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


