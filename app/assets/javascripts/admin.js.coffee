$ ->
  $('#send_newsletter_btn').click (e) ->
    e.preventDefault()
    $(@).parent().submit()

  $('.promote_user, .demote_admin').click (e) ->
    e.preventDefault()
    $.ajax $(@).attr('href'),
      type: 'POST'
      success: (data) ->
        window.location.reload()
      error: (data) ->
        alert(data.responseText)