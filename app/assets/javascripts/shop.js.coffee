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
    $.ajax
      type: 'POST'
      url: $(@).attr('href')
      success: (data) ->
        window.location.reload()
      error: (data) ->
         window.location.reload()

