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

  $('#add_review').on 'click', (e) ->
    e.preventDefault()
    $('#rating').raty({
      half: true,
      path: '/',
      score: 0})
    $('#review_text').val('')
    $('#review_modal').modal 'show'

  $('#review_form').on 'submit', (e) ->
    e.preventDefault()
    product_id = window.location.pathname.split('product/')[1]
    score = $("input[name='score']").val()
    text = $('#review_text').val()
    $.ajax '/review/new',
      type: 'POST'
      data:
        product_id: product_id
        score: score
        text: text
      success: ->
        window.location.reload()

  $('#show_reviews').on 'click', (e) ->
    e.preventDefault()
    product_id = window.location.pathname.split('product/')[1]
    $.ajax '/review/show',
      type: 'GET'
      data:
        product_id: product_id
      success: (data) ->
        $('#show_reviews').addClass('hidden')
        $('.review_container').append(data)
        ratings = $('.rating')
        $.each ratings, (rating) ->
          $(@).raty({
            score: $(@).attr('data-score'),
            half: true,
            path: '/',
            readOnly: true})

  $(document).on 'click', '.delete-review', (e) ->
    e.preventDefault()
    id = $(@).attr('data-id')
    $.ajax '/review/delete',
      type: 'POST'
      data:
        id: id
      success: ->
        window.location.reload()
