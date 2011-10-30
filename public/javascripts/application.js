$(document).ready(function(){
  showFlashMessages();
});

function showFlashMessages(){
  var content = ''
  if ($('#notice').length > 0){
    content = $('#notice').html();
  }
  else if ($('#alert').length > 0){
    content = $('#alert').html();
  }

if (content.length >0){
  $.msg({
	bgPath : '/images/',
    autoUnblock: false,
    css: {
      border: '1px solid #ff3300'
    },
    content: content
  });
}
}