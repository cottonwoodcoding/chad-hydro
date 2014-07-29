$ ->
  $('.category').livequery ->
    $(@).click (e) ->
      e.preventDefault()
      $.ajax
        type: 'GET'
        url: '/sort_by_category'
        data: {'category' : $(@).text().trim()}
        success: (data) ->
          $('#products').html(data)
        error: (data) ->
          alert('Could not load products. Please try again.')
