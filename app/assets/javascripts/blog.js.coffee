$ ->
  underline = ->
    $('.post-title').removeClass('underline')
    $('.post-title').each ->
      $(@).addClass('underline') if $(@).attr('data-id') == $('.article-title').attr('data-id')

  $('.post').dotdotdot
    ellipsis: '...',
    wrap: 'letter',
    row: 1

  $('.panel-group').on 'shown.bs.collapse hidden.bs.collapse', (e) ->
    $(e.target).siblings().find('.caret-toggle').toggleClass('fa-caret-down fa-caret-right')

  $('.post-title').on 'click', (e) ->
    e.preventDefault()
    post = $(@).siblings('.data')
    $('.article-title').text(post.data('title'))
    $('.article-body').html(post.data('body'))
    $('.article-author').text("#{post.data('author')} - #{post.data('date')}")
    $('.article-title').attr('data-id', post.data('article_id'))
    underline()

  window.onload = ->
    underline()
