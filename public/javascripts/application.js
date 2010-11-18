$(function() {
$("#notice").delay(7000).fadeOut('slow');

$(".ib-button").hover(
    function() {$(this).addClass('ui-state-hover'); },
    function() {$(this).removeClass('ui-state-hover');}
      );
$("#new_board_button").click(function() {$("#new_board_form").show('blind');});
});
