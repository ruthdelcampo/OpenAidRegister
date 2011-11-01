// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//jQuery.noConflict();

var map;
var markers = [];
var marker;
var geocoder;
var map_bounds;


$(document).ready(function(){

	$( "#datepicker" ).datepicker();

  $( "#datepicker2" ).datepicker();

//Initalize
    var latlng = new google.maps.LatLng(14.5, 15.5);
    var myOptions = {
      zoom: 3,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDoubleClickZoom: true
    };
//Paint the map
    map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);

   //Add the listener to add a marker
	google.maps.event.addListener(map, 'click', addMarker);

	// Remove markers
	google.maps.event.addListener(map, 'dblclick', removeMarker)

	//parse possible existing points
	if (!($("#google_markers").val()=='POINT EMPTY' || $("#google_markers").val()=='MULTIPOINT EMPTY' || $("#google_markers").val()=="")) {
    parseWkt($("#google_markers").val());
	}

  map.fitBounds(map_bounds);

  sectors();
  otherOrganizations();
  change_contact_info();
  showErrors();
});

function showErrors(){
  if ($("#errors").length > 0){
    $('html,body').animate({scrollTop: $("#errors").offset().top - 15}, 1000);
  }
}

function addMarker(event) {
	marker = new google.maps.Marker({
	    map:map,
	    draggable:true,
	    position: event.latLng
	  });

	markers.push(marker);

  var marker_index = markers.length;

	// Change an existing marker
	google.maps.event.addListener(marker, 'dragend', function(event){
    $("#google_markers").val(generateWkt());
    geocodePoint(event.latLng, marker_index);
    enableOrDisableGeodetail();
  });

	$("#google_markers").val(generateWkt());
  geocodePoint(event.latLng, markers.length);
  enableOrDisableGeodetail();
}

function removeMarker(evt) {
	if (markers) {
    for (i in markers) {
      markers[i].setMap(null);
    }
    markers = [];
  }
  $("#google_markers").val("");
  removeGeocoding();
}

function generateWkt() {
	//well known text   POINT(10 40, 12 35, 20 30)
	var markersAux = [];
	$.each(markers,function(index, value) {
		markersAux.push( value.position.lng()+" "+value.position.lat());
	});
	return "MULTIPOINT (" + markersAux.join(",") + ")";
}


function parseWkt(wkt) {
	var procstring;
	var auxarr;

  if (!map_bounds) {
    map_bounds = new google.maps.LatLngBounds();
  }

	procstring = $.trim(wkt.replace("MULTIPOINT",""));
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

    map_bounds.extend(marker.getPosition());

    var marker_index = markers.length;

    geocodePoint(marker.getPosition(), marker_index);
    enableOrDisableGeodetail();

    // Change an existing marker
    google.maps.event.addListener(marker, 'dragend', function(event){
      $("#google_markers").val(generateWkt());
      geocodePoint(event.latLng, marker_index);
      enableOrDisableGeodetail();
    });
	});
}

function geocodePoint(latLong, marker_id){
  if (!geocoder){
    geocoder = new google.maps.Geocoder();
  }

  geocoder.geocode({location: latLong}, function(results, status){
    var city, region, country;

    if (status == 'OK'){
      if (results.length > 0){
        $.each(results[0].address_components, function(index, item){
          if (item.types[0] == 'administrative_area_level_2'){
            city = item.long_name;
          }
          if (item.types[0] == 'administrative_area_level_1'){
            region = item.long_name;
          }
          if (item.types[0] == 'country'){
            country = item.long_name;
          }
        });
        $('#location ul.reverse_geo li.marker_' + marker_id).remove();
        $('#location ul.reverse_geo').append($(
          '<li class="marker_' + marker_id + '">' +
          '  <input type="hidden" name="reverse_geo[][latlng]" value="' + latLong.lng() + ' ' + latLong.lat()  + '" />' +
          '  <input type="hidden" name="reverse_geo[][adm2]" value="' + city + '" />' +
          '  <input type="hidden" name="reverse_geo[][adm1]" value="' + region + '" />' +
          '  <input type="hidden" name="reverse_geo[][country]" value="' + country + '" />' +
          '  <input type="hidden" name="reverse_geo[][level_detail]" value="' + $('#location input.geo_detail:checked').val() + '" />' +
          '</li>'
        ));
      }
    }
  });
}

function removeGeocoding(){
  $('#location ul.reverse_geo li').remove();
  enableOrDisableGeodetail();
}

function enableOrDisableGeodetail(){
  if (markers.length > 0){
    $('#location input.geo_detail').attr('disabled', true);
  }else{
    $('#location input.geo_detail').attr('disabled', false);
  }
}

// for the checkbox same person in project show
function change_contact_info() {
  $('#same_person').change(function(){
    if ($(this).is(':checked')){
      $("#contact_name").val(contact_name);
      $("#contact_email").val(contact_email);
    }else{
      $("#contact_name").val(null);
      $("#contact_email").val(null);
    }
  });
}

function sectors(){
  var sectors = $('#sector_id');

  sectors.change(function(evt){
    evt.preventDefault();
    var sector_id = $.trim($(this).find('option:selected').val());
    var sector_name = $.trim($(this).find('option:selected').text());

    if (sector_id != '' && sector_name != '') {
      var existing_li = sectors.closest('ul').find('li:not(.add_new):contains(' + sector_name + ')');
      if (existing_li.length > 0){
        existing_li.find('div').effect('highlight', {'color': '#FF3300'}, 200);
        return;
      }

      var li = $('<li>' +
      '<div class="health"><a href="#">' + sector_name + '&nbsp;<img src="/images/cross.gif" alt="" /></a></div>' +
      '  <input type="hidden" name="sectors[][id]" value="' + sector_id + '" />' +
      '</li>');

      $(this).closest('ul').find('li.add_new').before(li);
    }
  })

  $('#sectors_list').find('li:not(.add_new) a').live('click', function(evt){
    evt.preventDefault();
    $(this).closest('li').remove();
  });
}

function otherOrganizations(){
  var list = $('#participating_orgs'),
      button = $('#add_partipating_org'),
      other_org_name = $('#other_org_name'),
      other_org_role = $('#other_org_role');

  list.find('li:not(.add_new) a').live('click', function(evt){
    evt.preventDefault();
    $(this).closest('li').remove();
  });

  button.click(function(evt){
    evt.preventDefault();
    var org_name = $.trim(other_org_name.val());
    var org_role = $.trim(other_org_role.find('option:selected').text());
    if (org_name != '' && org_role != '') {
      var existing_li = list.find('li:not(.add_new):contains(' + org_name + '):contains(' + org_role + ')');
      if (existing_li.length > 0){
        existing_li.find('div').effect('highlight', {'color': '#FF3300'}, 200);
        return;
      }
      var li = $('<li>' +
      '  <div class="health"><a href="#">' + org_name + '</a><em>AS</em><a href="#" class="last">' + org_role + '&nbsp;<img src="/images/cross.gif" alt="" /></a></div>' +
      '  <input type="hidden" name="participating_orgs[][name]" value="' + org_name + '" />' +
      '  <input type="hidden" name="participating_orgs[][role]" value="' + org_role + '" />' +
      '</li>');

      list.find('li.add_new').before(li);
      other_org_name.val('');
      other_org_role.val('');
    }
  });
}
