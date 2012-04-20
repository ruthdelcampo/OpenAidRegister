
$(document).ready(function() {
	var counter = true

	var refreshId = setInterval(function(){
		if (counter){
		  $("#body_container #info_item_1").hide();
		  $("#body_container #info_item_2").show();
		}else{
		  $("#body_container #info_item_2").hide();
		  $("#body_container #info_item_1").show();
		}
		counter = !counter
	}, 6000);

});
