$(document).ready(function() {
	$('a.publish-window').click(function() {
		
         //Getting the variable's value from a link 
		var publishBox = $(this).attr('href');

		//Fade in the Popup
		$(publishBox).fadeIn(300);
		
		//Set the center alignment padding + border see css style
		var popMargTop = ($(publishBox).height() + 24) / 2; 
		var popMargLeft = ($(publishBox).width() + 24) / 2; 
		
		$(publishBox).css({ 
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});
		
		// Add the mask to body
		$('body').append('<div id="mask"></div>');
		$('#mask').fadeIn(300);
		
		return false;
	});
	
	// When clicking on the button close or the mask layer the popup closed
	$('a.close, #mask').live('click', function() { 
	  $('#mask , .publish-popup').fadeOut(300 , function() {
		$('#mask').remove();  
	}); 
	return false;
	});
	
	// when the user press the button, then check the content of the input and return it to controller
	$('div').find('.publish-popup').find('form').find('button').click (function() {
		var str = $(this).serialize();  	
		// -- Start AJAX Call --
		$.ajax({
		    type: "POST",
		    url: "/publish",  // Send the login info to this page
		    data: str,
		    success: function(msg){ 
		$("#status").ajaxComplete(function(event, request, settings){ 
		 // Show 'Submit' Button
		$('#submit').show();
		// Hide Gif Spinning Rotator
		$('#ajax_loading').hide(); 
		 if(msg == 'OK') // LOGIN OK?
		 {
		 var login_response = '<div id="logged_in">' +
		'<div style="width: 350px; float: left; margin-left: 70px;">' +
		'<div style="width: 40px; float: left;">' +
		'<img style="margin: 10px 0px 10px 0px;" align="absmiddle" src="images/ajax-loader.gif">' +
		'</div>' +
		'<div style="margin: 10px 0px 0px 10px; float: right; width: 300px;">'+
		"You are successfully logged in! <br /> Please wait while you're redirected...</div></div>";

		$('a.modalCloseImg').hide(); 
		$('#simplemodal-container').css("width","500px");
		$('#simplemodal-container').css("height","120px");

		 $(this).html(login_response); // Refers to 'status'

		// After 3 seconds redirect the
		setTimeout('go_to_private_page()', 3000);
		 }
		 else // ERROR?
		 {
		 var login_response = msg;
		 $('#login_response').html(login_response);
		 } 

		 }); 

		 } 
		  }); 

		// -- End AJAX Call --
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		 
	  $('#mask , .publish-popup').fadeOut(300 , function() {
		$('#mask').remove();  
	});	return false;
		});
	
	// checking if the user already contains the api key for ckan and the name of the ckan pakage
	function generate() { 
		if ($('#').is(':checked')) {
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
	
	
	
	
});



/*** 

<!--- <script type="text/javascript">
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);
      // Callback that creates and populates a data table, 
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {
      // Create the data table.
      	var data = new google.visualization.DataTable();
      data.addColumn('string', 'Sector Name');
      data.addColumn('number', 'Projects');
		<% @sector_distribution.each do |sector| %>
	data.addRow(['<%=sector.name %>', <%=sector.countnumofprojectsinthissector%>] );
    <%end%>
      // Set chart options
      var options = {'title':'Project Sector Distribution in your organization',
                     'width':300,
                     'height':200};
      // Instantiate and draw our chart, passing in some options.
      var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
    </script>

-->

*/