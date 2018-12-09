$(document).ready(() => {
  
  $('.initial-stats').on('mouseenter', (event) => {
      var tips = $(event.currentTarget).attr('data-tips');
      var length = $(event.currentTarget).attr('data-length');
      $('.player-stats').children('span').text(tips);
      $('.title').css('margin-left', length);
    });
      $('.player-stats').on('mouseleave', (event) => {
      $('.player-stats').children('span').empty();
    });
  
});