$ ->

  $("#list").click (event) ->
    event.preventDefault()
    $("#products .item").addClass "list-group-item"

  $("#grid").click (event) ->
    event.preventDefault()
    $("#products .item").removeClass "list-group-item"
    $("#products .item").addClass "grid-group-item"

  $('.body-container').dotdotdot({
      ellipsis: '...',
      wrap: 'word',
      row: 5,
      after: 'a.readmore'
    })

  $('.body-container').each ->
    truncated = $(@).triggerHandler('isTruncated')
    $(@).children().children('.readmore').removeClass('hidden') if truncated
