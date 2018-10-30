# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#calendar').fullCalendar {
    header:{
      left:"prev,today,next",
      center: 'title',
      right: 'month, agendaWeek, agendaDay, listYear'
    }
    }
  return

$(document).on 'turbolinks:before-cache', ->
  $('#calendar').empty()
  return