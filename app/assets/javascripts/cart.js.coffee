$ ->
  $('#modal_add_to_cart').click (e) ->
    e.preventDefault()
    $addButton = $(@)
    $addButton.attr('disabled', 'disabled')
    $addButton.html('adding to cart...')
    href = $(e.target).attr('href')
    quantity = $('#product_quantity').val()
    href = href.replace(href.substring(href.lastIndexOf("/"), href.length), "/#{quantity}")
    $.ajax
      type: 'POST'
      url: href
      success: (data) ->
        window.location.reload()
      error: (data) ->
        responseText = data.responseText
        if responseText.trim() == 'You need to sign in or sign up before continuing.'
          window.location.href = '/users/sign_in'
        else
          $addButton.removeAttr('disabled')
          $addButton.html('add to cart')
          alert('Something went wrong while trying to add your item. Please try again.')

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

  $('.checkout').click (e) ->
    e.preventDefault()
    $checkoutButton = $(@)
    $checkoutButton.html('Taking You To Paypal...')
    $('a:visible').attr('disabled', 'disabled')
    $checkoutButton.attr('disabled', 'disabled')
    $.ajax '/cart/user_check',
      type: 'POST'
      data: {'checkout_url' : $checkoutButton.attr('href'), 'total' : $('#cart_total').text()}
      success: (data) ->
        window.location.href = data
      error: (data) ->
        $checkoutButton.html('Checkout')
        $checkoutButton.removeAttr('disabled')
        alert('An error occurred while redirecting you to Paypal. Please try again or email support@moonlightgardensupply.com.')



