# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


initialize_calendar = ->
  $('.calendar').each ->
    calendar = $(this)
    calendar.fullCalendar
      header:
        left: 'prev,next today'
        center: 'title'
        right: 'month,agendaWeek,agendaDay'
      selectable: true
      selectHelper: true
      editable: true
      eventLimit: true
      events: '/teams/:team_id/events.json'
      select: (start, end) ->
        $('div[data-team_manager]' ).each ->
          team_manager = $(this).data('team_manager')
          if team_manager is true
            $.getScript '/teams/:team_id/events/new', ->
              $('#event_date_range').val moment(start).format('MM/DD/YYYY HH:mm') + ' - ' + moment(end).format('MM/DD/YYYY HH:mm')
              date_range_picker()
              $('.start_hidden').val moment(start).format('YYYY-MM-DD HH:mm')
              $('.end_hidden').val moment(end).format('YYYY-MM-DD HH:mm')
              return
            calendar.fullCalendar 'unselect'
            return
          return
        return
      eventDrop: (event, delta, revertFunc) ->
        $('div[data-team_manager]' ).each ->
          team_manager = $(this).data('team_manager')
          if team_manager is true
            event_data = event:
              id: event.id
              start: event.start.format()
              end: event.end.format()
            $.ajax
              url: event.update_url
              data: event_data
              type: 'PATCH'
            return
          return
        return
      eventClick: (event, jsEvent, view) ->
        $('div[data-team_manager]' ).each ->
          team_manager = $(this).data('team_manager')
          if team_manager is true
            $.getScript event.edit_url, ->
              $('#event_date_range').val moment(event.start).format('MM/DD/YYYY HH:mm') + ' - ' + moment(event.end).format('MM/DD/YYYY HH:mm')
              date_range_picker()
              $('.start_hidden').val moment(event.start).format('YYYY-MM-DD HH:mm')
              $('.end_hidden').val moment(event.end).format('YYYY-MM-DD HH:mm')
              return
            return
          return
        return
    return
  return

$(document).on 'turbolinks:load', initialize_calendar