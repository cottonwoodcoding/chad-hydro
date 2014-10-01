$ ->
    setInterval (->
      $heart = $('#footer i')
      if $heart.hasClass('red')
        $heart.removeClass('red')
      else
        $heart.addClass('red')
      return
    ), 1000

    $('#submit_purchase').click ->
      $(@).html('Submitting Purchase...')
      $(@).attr('disabled', 'disabled')
      $('#review_form').submit()

    $('.picker').timepicker()

    $('.alert').show ->

      setTimeout (->
        $('.alert').slideToggle()
        return
      ), 3000

      $.amaran({
        content:{
          'message' : $(@).text().trim(),
          'bgcolor' : '#46ad46',
          'color' : '#fff'
        },
        theme:'colorful'})

    $navItems = $('.nav_item')
    boldClass = 'header-bold-text'
    $navItems.removeClass(boldClass)
    path = window.location.pathname

    if path == '/'
      $('.nav_item:first').addClass(boldClass)
    else
      $navItems.each ->
        $(@).addClass(boldClass) if $(@).attr('href') == path
