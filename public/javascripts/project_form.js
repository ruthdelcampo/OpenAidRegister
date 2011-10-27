// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//jQuery.noConflict();

var map;
var markers = [];
var marker;


$(document).ready(function(){ 
	
		$( "#datepicker" ).datepicker();
		$( "#datepicker2" ).datepicker();
		
    var latlng = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);

   //Add the listener to add a marker
	google.maps.event.addListener(map, 'click', addMarker);
	
	// Remove markers
	google.maps.event.addListener(map, 'dblclick', removeMarker)
	
	
	//parse possible existing points
	if (!($("#google_markers").val()=='POINT EMPTY' || $("#google_markers").val()=="")) {
	parseWkt($("#google_markers").val());
	}

});

function addMarker(event) {
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    position: event.latLng
	  });
	markers.push(marker);
	$("#google_markers").val(generateWkt());
	
}

function removeMarker()
{
	
	if (markers) {
    for (i in markers) {
      markers[i].setMap(null);
    }
    markers.length = 0;
  }
	
}

function generateWkt() {
	//well known text   POINT(10 40, 12 35, 20 30)
	var markersAux = [];
	$.each(markers,function(index,value) {
		//markersAux.push("("+value.position.lng()+" "+value.position.lat()+")");
		markersAux.push( value.position.lng()+" "+value.position.lat());
	});
	return "POINT (" + markersAux.join(",") + ")";
}


function parseWkt(wkt) {
	var procstring;
	var auxarr;
	procstring = $.trim(wkt.replace("POINT",""));
	procstring = procstring.slice(0,-1).slice(1);
	auxarr = procstring.split(",");
	$.each(auxarr,function(index,value) {
		//var txt = $.trim(value).slice(0,-1).slice(1);
		//var coords = txt.split(" ");
		var coords = value.split(" ");
		marker = new google.maps.Marker({
		    map:map,
		    draggable:true,
		    position: new google.maps.LatLng(coords[1], coords[0])
		  });		
		markers.push(marker);
	});
}


// for the checkbox same person in project show
function change_contact_info() { 
	if ($('#same_person').is(':checked')) {
	$("#contact_name").val("<%= session[:organization].contact_name %>");
	$("#contact_email").val("<%= session[:organization].email %>");
}else{
	$("#contact_name").removeAttr('disabled');
		$("#contact_name").val('');
			$("#contact_email").removeAttr('disabled');
				$("#contact_email").val('');
}
	return false

}