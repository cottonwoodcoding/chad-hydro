$ ->
  $('.category a').livequery ->
    $(@).click (e) ->
      e.preventDefault()
      $link = $(@)
      $.ajax
        type: 'GET'
        url: '/sort_by_category'
        data: {'category' : $link.attr('value')}
        success: (data) ->
          $('#products').html(data)
          $('#shop_header').html("Shop - #{$link.text()}")
        error: (data) ->
          alert('Could not load products. Please try again.')
