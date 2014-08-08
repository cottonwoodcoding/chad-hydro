$ ->
  underline = ->
    $('.post-title').removeClass('link-change')
    $('.post-title').each ->
      if $(@).attr('data-id') == $('.article-title').attr('data-id')
        $(@).addClass('link-change')
        $('.comment-article-id').val($(@).attr('data-id'))

  $(document).on 'click', '.remove-comment', (e) ->
    e.preventDefault()
    id = $(@).attr('data-id')
    $("#comment_#{id}").addClass('fade-out')
    response = confirm("Really delete this comment?")
    if response
      $.ajax '/blog/delete_comment',
        type: 'POST'
        data:
          id: id
        success: ->
          $("#comment_#{id}").remove()
          $("#hr_#{id}").remove()
          $('.comment-count').text("#{$('.comment').length}")
        error: (data) ->
          $("#comment_#{id}").removeClass('fade-out')
          alert('Something went wrong try again')
    else
      $("#comment_#{id}").removeClass('fade-out')

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

  $('.fa-radio').on 'change', ->
    id = $(this).attr('name')
    help = $("#help_#{id}")
    icons = $(".icon-#{id}")
    icons.each ->
      $(@).removeClass('wait-color approve-color delete-color')
      $(@).addClass('icon-faded')

    if $(@).hasClass('wait-label')
      icon = $("#icon_wait_#{id}")
      icon.addClass('wait-color')
      icon.removeClass('icon-faded')
      help.text('* Comment will be ignored')
    else if $(@).hasClass('approve-label')
      icon = $("#icon_approve_#{id}")
      icon.addClass('approve-color')
      icon.removeClass('icon-faded')
      help.text('* Comment will be published')
    else
      icon = $("#icon_delete_#{id}")
      icon.addClass('delete-color')
      icon.removeClass('icon-faded')
      help.text('* Comment will be deleted')

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
