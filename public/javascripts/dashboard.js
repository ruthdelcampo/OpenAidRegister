this.oar = (_ref = window.oar) != null ? _ref : {};

var map_bounds;
var all_markers = [];
var OARIcon;

$(document).ready(function(){
	initMap();
	initUploadForm();
  oar.listFilter($("#projects_search"), $(".content"));
});

// initMap
//----------------------------------------------------------------------

function initMap(){
	map = new L.Map('map_canvas').setView(new L.LatLng(33, 0), 1);
	
	OARIcon = L.Icon.extend({
	  iconUrl: 'images/marker_single_selected.png',
	  shadowUrl: null,
	  iconSize: new L.Point(19, 19),
	  iconAnchor: new L.Point(9, 9),
	  popupAnchor: new L.Point(1, 10)
	});
	
	var url = 'http://a.tiles.mapbox.com/v3/openaidregister.map-xczbkkrw.jsonp'; //Mapbox Streets
	wax.tilejson(url, function(tilejson) {
	        // Add MapBox Streets as a base layer
	        map.addLayer(new wax.leaf.connector(tilejson));
	});



	$.each(ordered_projects_list, function(index, project){
		if (!(project.markers == 'NIL' || project.markers == 'NULL' || project.markers == "")) {
			parseWkt(project);
		}
	});

	// set zoom and center when there is only one location...
  // if not, the zoom is at top level and the visualization is weird
	/*if (all_markers.length === 1) {
		map.setView(map_bounds.getCenter(),6);
	} else {
		map.fitBounds(map_bounds);
	}*/
	
}

// parseWkt
//----------------------------------------------------------------------

function parseWkt(project) {

  var wkt = project.markers;
	var procstring;
	var auxarr;

  if (!map_bounds) {
    map_bounds = new L.LatLngBounds;
  }

	$.each(wkt[0],function(index,value) {
	  var coords = value.split(" ");
		var icon = new OARIcon();
		marker = new L.Marker(new L.LatLng(coords[1], coords[0]), {icon: icon});
		marker.bindPopup('<a href="/projects/'+project.info.id+'/edit">'+project.info.name+'</a>');

		all_markers.push(marker);
    	//createInfowindow(marker, project);
    	map_bounds.extend(marker.getLatLng());
		map.addLayer(marker);
	});
}

// createInfoWindow
//----------------------------------------------------------------------

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

// initUploadForm
//----------------------------------------------------------------------

function initUploadForm(){
	var input = $('.dashboard_right .project_details .add_project form input');

	input.change(function(){
		$(this).closest('form').submit();
	});
}
