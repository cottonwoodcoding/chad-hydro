$ ->
  $('.nav_item').click (e) ->
    e.preventDefault()
    if !$(@).hasClass('brown-background')
      $('.nav_item').removeClass('brown-background')
      href = $(@).attr('href')
      $.ajax
        type: 'GET'
        url: href
        success: (data) ->
          $('#content').html(data)
          $("a[href='#{href}']").addClass('brown-background')
        error: (data) ->
          alert(data)