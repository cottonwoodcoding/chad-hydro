$ ->
  underline = ->
    $('.post-title').removeClass('link-change')
    $('.post-title').each ->
      if $(@).attr('data-id') == $('.article-title').attr('data-id')
        $(@).addClass('link-change')
        $('.comment-article-id').val($(@).attr('data-id'))

  $('#anon').change ->
    if $(@).is(':checked')
      $('#name').val('anonymous')
      $('#name').attr('disabled', 'true')
    else
      $('#name').val('')
      $('#name').prop('disabled', null)

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
    $('.comment-container').children().remove()
    $.ajax '/blog/update_comments',
      type: 'GET'
      data:
        article_id: post.data('article_id')
      success: (data) ->
        $('.comment-container').append(data)
        $('.comment-count').text($('.comment').length)
      error: (data) ->
        $('.comment-count').text('0')
        $('.comment-container').append('<p> Error retrieving comments')

  window.onload = ->
    underline()
