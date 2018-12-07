$(document).ready(() => {
  
  $('.initial-stats').on('mouseenter', (event) => {
      var tips = $(event.currentTarget).attr('data-tips');
      var length = $(event.currentTarget).attr('data-length');
      $('.player-stats').children('span').text(tips);
      //$('.player-stats').children('span').addClass('stats-absolute');
      $('.title').css('margin-left', length);
    });
      $('.player-stats').on('mouseleave', (event) => {
      $('.player-stats').children('span').empty();
      //$('.player-stats').children('span').removeClass('stats-absolute');
    });
  
  /*
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
  */
});