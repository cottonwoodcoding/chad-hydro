$ ->
  $('#send_newsletter_btn').click (e) ->
    e.preventDefault()
    $(@).parent().submit()