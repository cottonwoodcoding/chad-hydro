$ ->
    $navItems = $('.nav_item')
    boldClass = 'header-bold-text'
    $navItems.removeClass(boldClass)
    path = window.location.pathname

    if path == '/'
      $('.nav_item:first').addClass(boldClass)
    else if path.indexOf('/shop') > -1
      $('.navbar-nav li:nth-child(3)').addClass(boldClass)
    else
      $navItems.each ->
        $(@).addClass(boldClass) if $(@).attr('href') == path
