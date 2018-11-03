# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  
  create_event = (title, start, end) ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
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
  
  update_event = (id, title, start, end) ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
      if !options.crossDomain
        token = $('meta[name="csrf-token"]').attr('content')
        if token
          return jqXHR.setRequestHeader('X-CSRF-Token', token)
      return
    $.ajax(
      type: 'post'
      url: '/events/update'
      data:
        id: id
        title: title
        start: start.toISOString()
        end: end.toISOString()).done((data) ->
      alert '更新しました!'
      return
    ).fail (data) ->
      alert '更新できませんでした。'
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
      if title
        eventData =
          title: title
          start: start
          end: end
        $('#calendar').fullCalendar 'renderEvent', eventData, true
        $('#calendar').fullCalendar 'unselect'
        create_event title, start, end
      return
    
    eventClick: (event, element) ->
      title = prompt('イベントを変更')
      $('#calendar').fullCalendar 'updateEvent', event
      update_event event.id, title, event.start, event.end
      return
    
    timezone: 'UTC'
    events: '/events.json'
    editable: true
    
  return

$(document).on 'turbolinks:before-cache', ->
  $('#calendar').empty()
  return