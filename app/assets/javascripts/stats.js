$(document).ready(() => {
  /*
  $(document).on({
      'mouseenter': function(event) {
      var tips = $(event.currentTarget).attr('data-tips');
      $(event.currentTarget).text(tips);
      $(event.currentTarget).css('font-size', '8px');
    },
      'mouseleave': function(event) {
      var order = $(event.currentTarget).attr('data-order');
      $(event.currentTarget).text(order);
      $(event.currentTarget).css('font-size', '12px');
    }
  }, '.initial-stats');
  */
  
  $(document).on({
      'mouseenter': function(event) {
      var tips = $(event.currentTarget).attr('data-tips');
      $('.player-stats').children('p').text(tips);
      //$('.player-stats').children('p').removeClass('hide');
      //$('.player-stats').children('p').addClass('stats-relative');
      //$(event.currentTarget).addClass('absolute');
    },
      'mouseleave': function(event) {
      $('.player-stats').children('p').empty();
      //$('.player-stats').children('p').addClass('hide');
      //$('.player-stats').children('p').removeClass('stats-relative');
      //$(event.currentTarget).removeClass('absolute');
    }
  }, '.initial-stats');
  
});