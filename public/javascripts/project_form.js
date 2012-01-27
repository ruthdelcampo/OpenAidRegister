// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//jQuery.noConflict();

var map;
var markers = [];
var marker;
var geocoder;
var map_bounds;
var marker_id;

$(document).ready(function(){

  $( "#datepicker" ).datepicker();
  $( "#datepicker2" ).datepicker();
  $( "#datepicker3" ).datepicker();
  $( "#accordion" ).accordion({
	  active: false, //initites all items collapsed
	  collapsible: true, //all can be collapsed
	  header: 'h3' //this identifies the separator for every collapsible part
  });

  //Initalize
  var latlng = new google.maps.LatLng(14.5, 15.5);
  var myOptions = {
    zoom: 3,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDoubleClickZoom: true
  };

	//Paint the map
  map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
	//Add the listener to add a marker
	google.maps.event.addListener(map, 'dblclick', addMarker);
	//parse possible existing points
	if (!($("#latlng").val()=='' || $("#latlng").val()==="[]" )) {
  //  console.log($('#location ul.reverse_geo'));
    parseWkt($("#latlng").val());
	};

	//set zoom and center when there is only one location...ifnot, the zoom is at top level and the visualization is weird
	if (markers.length === 1) {
		map.setCenter(map_bounds.getCenter());
	  map.setZoom(8);
	} else {
	  map.fitBounds(map_bounds);
	};


  sectors();
  otherOrganizations();
  change_contact_info();
  showErrors();
  deleteAll();
	transactions();
	relatedDocuments();

});

function showErrors(){
  if ($("#errors").length > 0){
    $('html,body').animate({scrollTop: $("#errors").offset().top - 15}, 1000);
  }
};

function deleteAll(){
	$('#delete_points').click(function(event) {
		removeMarker();
    event.preventDefault();
  });
};

function addMarker(event) {
	marker = new google.maps.Marker({
	  map:map,
	  draggable:false,
	  position: event.latLng
	});

	markers.push(marker);
  geocodePoint(marker);
  enableOrDisableGeodetail();

	// Change an existing marker
  //	google.maps.event.addListener(marker, 'dragend', function(event){
  //  geocodePoints(markers, markers.length);
  //    enableOrDisableGeodetail();
  // });
};

function removeMarker() {
	if (markers) {
    for (i in markers) {
      markers[i].setMap(null);
    }
    markers = [];
  }
  removeGeocoding();
};


function parseWkt(wkt) {
	var procstring;
	var auxarr;
  if (!map_bounds) {
    map_bounds = new google.maps.LatLngBounds();
  }
	procstring = wkt.slice(0,-1).slice(1);
	auxarr = procstring.split(",");
	$.each(auxarr,function(index,value) {
		var txt = $.trim(value).slice(0,-1).slice(1);
		var coords = txt.split(" ");
		marker = new google.maps.Marker({
		  map:map,
		  draggable:false,
		  position: new google.maps.LatLng(coords[1], coords[0])
		});
		markers.push(marker);
	  //	geocodePoint(marker);
    map_bounds.extend(marker.getPosition());
    enableOrDisableGeodetail();
    // Change an existing marker
    //google.maps.event.addListener(marker, 'dragend', function(event){
	  //geocodePoints(markers, markers.length);
    // enableOrDisableGeodetail();
    //});
	});
	//geocodePoint(marker);
};

function geocodePoint(marker){
  if (!geocoder){
    geocoder = new google.maps.Geocoder();
  }
  //First delete all previous
  //$('#location ul.reverse_geo li').remove();
  // $.each(markers, function(i, value){
  geocoder.geocode({location: marker.position}, function(results, status){
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
            country = item.short_name;
			      country_extended = item.long_name;
          }
        });
        $('#location ul.reverse_geo').append($(
          '<li class="marker_' + (markers.length*1) + '">' +
          '  <input type="hidden" name="reverse_geo[][latlng]" value="' + marker.position.lng() + ' ' + marker.position.lat()  + '" />' +
          '  <input type="hidden" name="reverse_geo[][adm2]" value="' + city + '" />' +
          '  <input type="hidden" name="reverse_geo[][adm1]" value="' + region + '" />' +
          '  <input type="hidden" name="reverse_geo[][country]" value="' + country + '" />' +
		  '  <input type="hidden" name="reverse_geo[][country_extended]" value="' + country_extended + '" />' +
          '  <input type="hidden" name="reverse_geo[][level_detail]" value="' + $('#location input.geo_detail:checked').val() + '" />' +
          '</li>'
        ));
      }
    }
  });
//});
  console.log($('#location ul.reverse_geo'));
};

function removeGeocoding(){
  $('#location ul.reverse_geo li').remove();
  enableOrDisableGeodetail();
};

function enableOrDisableGeodetail(){
  if (markers.length > 0){
    $('#location input.geo_detail').attr('disabled', true);
  }else{
    $('#location input.geo_detail').attr('disabled', false);
  }
};

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
};

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
};

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
};

function relatedDocuments(){
  var list = $('#related_docs'),
  button = $('#add_doc'),
  doc_url = $('#doc_url'),
  doc_type = $('#doc_type');

  //deleting elements
  list.find('li:not(.add_new) a').live('click', function(evt){
    evt.preventDefault();
    $(this).closest('li').remove();
  });


  button.click(function(evt){
    evt.preventDefault();
    var new_doc_url = $.trim(doc_url.val());
    var new_doc_type = $.trim(doc_type.find('option:selected').text());
    if (new_doc_url != '' && new_doc_type != '') {
      var existing_li = list.find('li:not(.add_new):contains(' + new_doc_url + '):contains(' + new_doc_type + ')');
      if (existing_li.length > 0){
        existing_li.find('div').effect('highlight', {'color': '#FF3300'}, 200);
        return;
      }
      var li = $('<li>' +
      '  <div class="health"><a href="#">' + new_doc_url + '</a><em>type</em><a href="#" class="last">' + new_doc_type + '&nbsp;<img src="/images/cross.gif" alt="" /></a></div>' +
      '  <input type="hidden" name="related_docs[][doc_url]" value="' + new_doc_url + '" />' +
      '  <input type="hidden" name="related_docs[][doc_type]" value="' + new_doc_type + '" />' +
      '</li>');

      list.find('li.add_new').before(li);
      doc_url.val('');
      doc_type.val('');
    }
  });
};

function transactions(){
	var transaction_list = $('#transaction_list'),
	transaction_button = $('#add_transaction'),
	transaction_type = $('#transaction_type'),
	transaction_value = $('#transaction_value'),
	transaction_currency = $('#transaction_currency'),
	transaction_date = $('#datepicker3'),
	provider_activity_id = $('#provider_activity_id'),
	provider_name = $('#provider_name'),
	provider_id = $('#provider_id'),
	receiver_activity_id = $('#receiver_activity_id'),
	receiver_name = $('#receiver_name'),
	receiver_id = $('#receiver_id'),
	transaction_description = $('#transaction_description');

	//deletes the clicked element
	transaction_list.find('li:not(.add_new) a').live('click', function(evt){
	  evt.preventDefault();
	  $(this).closest('li').remove();
	});

	//when the add more button is clicked...
	transaction_button.click(function(evt){
	  evt.preventDefault();
	  var transaction_type_new = $.trim(transaction_type.find('option:selected').text());
		var transaction_value_new = $.trim(transaction_value.val());
		var transaction_currency_new = $.trim(transaction_currency.find('option:selected').text());
		var transaction_date_new = $.trim(transaction_date.val());
		var provider_activity_id_new = $.trim(provider_activity_id.val());
		var provider_name_new = $.trim(provider_name.val());
		var provider_id_new = $.trim(provider_id.val());
		var receiver_activity_id_new = $.trim(receiver_activity_id.val());
		var receiver_name_new = $.trim(receiver_name.val());
		var receiver_id_new = $.trim(receiver_id.val());
		var transaction_description_new = $.trim(transaction_description.val());

	  if (transaction_value_new != '' && transaction_type_new != '' && transaction_date!= '') {

		  var li = $('<li>' +
	      '  <div class="health"><a href="#">' + transaction_value_new + '</a><em> AS </em><a href="#" class="last">' + transaction_type_new +
			'&nbsp;<img src="/images/cross.gif" alt="" /></a></div>' +
	      '  <input type="hidden" name="transaction_list[][transaction_value]" value="' + transaction_value_new + '" />' +
	      '  <input type="hidden" name="transaction_list[][transaction_type]" value="' + transaction_type_new + '" />' +
		  '  <input type="hidden" name="transaction_list[][transaction_currency]" value="' + transaction_currency_new + '" />' +
	      '  <input type="hidden" name="transaction_list[][transaction_date]" value="' + transaction_date_new + '" />' +
		  '  <input type="hidden" name="transaction_list[][provider_activity_id]" value="' + provider_activity_id_new + '" />' +
	      '  <input type="hidden" name="transaction_list[][provider_name]" value="' + provider_name_new + '" />' +
		  '  <input type="hidden" name="transaction_list[][provider_id]" value="' + provider_id_new + '" />' +
	      '  <input type="hidden" name="transaction_list[][receiver_activity_id]" value="' + receiver_activity_id_new + '" />' +
		  '  <input type="hidden" name="transaction_list[][receiver_name]" value="' + receiver_name_new + '" />' +
		  '  <input type="hidden" name="transaction_list[][receiver_id]" value="' + receiver_id_new + '" />' +
	      '  <input type="hidden" name="transaction_list[][transaction_description]" value="' + transaction_description_new + '" />' +
	      '</li>');

	    transaction_list.find('li.add_new').before(li);
	    transaction_type.val('');
	  	transaction_value.val('');
	    transaction_currency.val('');
	  	transaction_date.val('');
	    provider_activity_id.val('');
		  provider_name.val('');
	    provider_id.val('');
		  transaction_type.val('');
	    receiver_activity_id.val('');
		  receiver_name.val('');
	    receiver_id.val('');
		  transaction_description.val('');

		} else {


		}
	});
};
