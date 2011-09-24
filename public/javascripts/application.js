// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var map;
var markers = [];

$(document).ready(function(){ 
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);

   //Add the listener to add a marker
	google.maps.event.addListener(map, 'click', addMarker);



});

function addMarker(event) {
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    position: event.latLng
	  });
	markers.push(marker);
}

function generateWkt() {

}
