// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//jQuery.noConflict();

var map;
var markers = [];
var marker;


$(document).ready(function(){

		$( "#datepicker" ).datepicker();
		$( "#datepicker2" ).datepicker();

//Initalize
    var latlng = new google.maps.LatLng(40.69847032728747, -73.9514422416687);
    var myOptions = {
      zoom: 8,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
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
	return "MULTIPOINT (" + markersAux.join(",") + ")";
}


function parseWkt(wkt) {
	var procstring;
	var auxarr;
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
	});
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
