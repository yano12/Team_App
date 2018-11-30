$(document).ready(() => {
  $('.initial-stats').on('mouseenter', () => {
    $('.stats-title').show();
    $('.stats-title').removeClass('hide');
  });
  
  $('.stats-title').on('mouseleave', () => {
    $('.stats-title').hide();
  });
});