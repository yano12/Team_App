$(document).ready(() => {
  
  $(document).on({
    'mouseenter': function(event) {
      var tips = $(event.currentTarget).attr('data-tips');
      $(event.currentTarget).html(`<p>${tips}</p>`);
    },
    'mouseleave': function(event) {
      $(event.currentTarget).children('p').empty();
    }
  }, '.initial-stats');
});