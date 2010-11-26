$(function() {
$("#notice").delay(7000).fadeOut('slow');

$(".ib-button").hover(
    function() {$(this).addClass('ui-state-hover'); },
    function() {$(this).removeClass('ui-state-hover');}
      );
$("#new_board_button").toggle(function() {
  $("#new_board_form").fadeIn('fast');
},function() {$("#new_board_form").fadeOut('fast');});

$("#board_submit").button({
  icons: {
    primary:"ui-icon-check"
         }
});

$("#new_post_button").toggle(function() {
  $("#new_post_form").fadeIn('fast');
},function() {$("#new_post_form").fadeOut('fast');});

// Add posts form
$("#post_submit").button({
  icons: {primary: "ui-icon-plusthick"}
});
$('#drawbox').drawbox({
      caption:'This is a caption'
      , lineWidth:5
      , lineCap:'round'
      , lineJoin:'round'
      , colorSelector:true
      , showClear: false});

});    
