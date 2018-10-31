# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  create_event = (title, start, end) ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
      token = undefined
      if !options.crossDomain
        token = $('meta[name="csrf-token"]').attr('content')
        if token
          return jqXHR.setRequestHeader('X-CSRF-Token', token)
      return
    $.ajax(
      type: 'post'
      url: '/events/create'
      data:
        title: title
        start: start.toISOString()
        end: end.toISOString()).done((data) ->
      alert '登録しました!'
      return
    ).fail (data) ->
      alert '登録できませんでした。'
      return
    return

  $('#calendar').fullCalendar
    header:
      left: 'prev,today,next'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    navLinks: true
    selectable: true
    selectHelper: true
    select: (start, end) ->
      title = prompt('イベントを追加')
      eventData = undefined
      if title
        eventData =
          title: title
          start: start
          end: end
        $('#calendar').fullCalendar 'renderEvent', eventData, true
        $('#calendar').fullCalendar 'unselect'
        create_event title, start, end
      return
    timezone: 'UTC'
    events: '/events.json'
    editable: true
  return

$(document).on 'turbolinks:before-cache', ->
  $('#calendar').empty()
  return