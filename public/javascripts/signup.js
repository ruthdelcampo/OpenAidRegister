$(document).ready(function(){
	  showErrors();
});
function showErrors(){
  if ($("#errors").length > 0){

    $('html,body').animate({scrollTop: $("#errors").offset().top - 15}, 1000);
  }
}