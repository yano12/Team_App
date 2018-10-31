$(document).ready ->
  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
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
      return
    events: '/events.json'
    editable: true
  return