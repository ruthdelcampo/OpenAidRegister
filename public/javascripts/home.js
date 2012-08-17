
$(document).ready(function() {
	
	var refreshId = setInterval( showItems, 5000);
    
	var counter = 0,
        divs = $('#body_container #info_item_1, #body_container #info_item_2, #body_container #info_item_3');

    function showItems () {
        divs.hide() // hide all divs
            .filter(function (index) { return index == counter % 3; }) // figure out correct div to show
            .show(); // and show it

        counter++;
    }; // function to loop through divs and show correct div
 


});
