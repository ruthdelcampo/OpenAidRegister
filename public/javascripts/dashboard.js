var map_bounds;
var all_markers = [];
$(document).ready(function(){
	initMap();
	initUploadForm();
});

function initMap(){
	var latlng = new google.maps.LatLng(14.5, 15.5);
	var myOptions = {
		zoom: 3,
		center: latlng,
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		disableDoubleClickZoom: true
	};

	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

	$.each(ordered_projects_list, function(index, project){
		if (!(project.markers == 'NIL' || project.markers == 'NULL' || project.markers == "")) {
			parseWkt(project);

		}
	});

	//set zoom and center when there is only one location...ifnot, the zoom is at top level and the visualization is weird
	if (all_markers.length === 1) {
		map.setCenter(map_bounds.getCenter());
	 map.setZoom(6);
	} else {
	  	map.fitBounds(map_bounds);
	}

}

function parseWkt(project) {

  var wkt = project.markers;
	var procstring;
	var auxarr;

  if (!map_bounds) {
    map_bounds = new google.maps.LatLngBounds();
  }
	$.each(wkt[0],function(index,value) {
	var coords = value.split(" ");
		marker = new google.maps.Marker({
		    map:map,
		    draggable:true,
		    position: new google.maps.LatLng(coords[1], coords[0])
		  });

	all_markers.push(marker);
    createInfowindow(marker, project);
    map_bounds.extend(marker.getPosition());

	});
}

function createInfowindow(marker, project){
  var div = $('<div/>');
  if (project.info.name) {
    div.append($('<h3>' + project.info.name + '</h3>'));
  }
  if (project.info.sectors) {
    var ul = $('<ul/>');
    $.each(project.info.sectors, function(index, sector){
      ul.append($('<li> '+ sector + '</li>'));
    });
    div.append(ul);
  }
  if (project.info.budget) {
    div.append($('<span>' + project.info.budget + '</span><br />'));
  }
  if (project.info.start_date && project.info.end_date) {
    div.append($('<span>' + project.info.start_date + ' - ' + project.info.end_date + '</span><br />'));
  }

  google.maps.event.addListener(marker, 'click', function() {
    console.debug(div.html());
    new google.maps.InfoWindow({
      content: div.html()
    }).open(map, marker);

  });
}

function initUploadForm(){
	var input = $('.dashboard_right .project_details .add_project form input');

	input.change(function(){
		$(this).closest('form').submit();
	});
}
