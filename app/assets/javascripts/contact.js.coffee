$ ->
  if $('#map').is(':visible')
     handler = Gmaps.build("Google")
     handler.buildMap
       internal:
         id: "map"
     , ->
       marker = handler.addMarker({
         lat: 40.736356
         lng: -111.888581
       })
       handler.map.centerOn(marker)

  $('#contact_request').bind 'click', (e) ->
    e.preventDefault()
    $errors = 0
    $name = $('#name')
    $email = $('#email')
    $message = $('#message')
    $re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    $('.form-group').removeClass('has-error')
    if $name.val() == ''
      $name.closest('.form-group').addClass('has-error')
      $errors += 1
    if !$re.test($email.val())
      $email.closest('.form-group').addClass('has-error')
      $errors += 1
    if $message.val() == ''
      $message.closest('.form-group').addClass('has-error')
      $errors += 1
    if $errors == 0
      $.ajax
        url: '/submit_request'
        type: "POST"
        data: $('#contact-form form').serializeArray()

