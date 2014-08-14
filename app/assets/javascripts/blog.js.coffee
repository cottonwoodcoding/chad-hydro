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

  $(document).on 'click', '.remove-article', (e) ->
    e.preventDefault()
    id = $(@).siblings('.article-header').find('h2').attr('data-id')
    $('.main-article').addClass('fade-out')
    response = confirm('Really delete article?')
    if response
      $.ajax '/blog/delete_article',
        type: 'POST'
        data:
          id: id
        success: ->
          window.location.reload()
        error: ->
          alert("Something went wrong try again")
    else
      $('.main-article').removeClass('fade-out')

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
    $('.loader').addClass('hidden')
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

  $('#new_comment').on 'shown.bs.modal', ->
    $('#name').val('')
    $('#name').attr('disabled', false)
    $('#anon').attr('checked', false)
    $('#email').val('')
    $('#comments').val('')

  $('#new_comment').on 'submit', (e) ->
    $(@).modal('toggle')
    $('.loader').removeClass('hidden')


  window.onload = ->
    underline()
    link_id = $('.prev-link').attr('data-id')
    if link_id
      $("#link_#{link_id}").trigger 'click' unless link_id == $('.post-title')[0].id.split('_')[1]
    if tinyMCE.activeEditor and tinyMCE.activeEditor.id == 'edit'
      body = $('.body-html').attr('data-body')
      tinyMCE.activeEditor.setContent(body)
    if $('.main-article')
      $.ajax '/blog/reset_article_id',
        type: 'POST'
        data:
          id: $('.article-title').attr('data-id')
