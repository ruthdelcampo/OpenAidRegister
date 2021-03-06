$(document).ready(function(){
  showFlashMessages();
  enableEmbedWidgetButtons();

  if (BrowserDetect.browser == "Explorer" && BrowserDetect.version < 7){
    window.location = "/browser_not_supported";
  };

  // generic tooltips
  //----------------------------------------------------------------------

  $(".tip_top").tooltip({
	  position: "top center",
	  offset: [-2, 10],
	  effect: "fade",
	  opacity: 0.7
	});

  $(".tip_right").tooltip({
	  position: "center right",
	  offset: [-2, 10],
	  effect: "fade",
	  opacity: 0.7
	});

});

function enableEmbedWidgetButtons(){
  var widgetCode = $("#projects_widget_code").html();
  $(".embed_button").click(function(event){
    if (widgetCode.length > 0){
      $.msg({
	      bgPath : '/images/',
        autoUnblock : false,
        css : {
          border : '1px solid #ff3300'
        },
        content : widgetCode,
        afterBlock : function(){
          $("#jquery-msg-overlay textarea").focus();
          $("#jquery-msg-overlay textarea").select();
        }
      });
    }

    event.preventDefault();
  });
}

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

// browser detect
//----------------------------------------------------------------------

var BrowserDetect = {
	init: function () {
		this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
		this.version = this.searchVersion(navigator.userAgent)
			|| this.searchVersion(navigator.appVersion)
			|| "an unknown version";
		this.OS = this.searchString(this.dataOS) || "an unknown OS";
	},
	searchString: function (data) {
		for (var i=0;i<data.length;i++)	{
			var dataString = data[i].string;
			var dataProp = data[i].prop;
			this.versionSearchString = data[i].versionSearch || data[i].identity;
			if (dataString) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp)
				return data[i].identity;
		}
	},
	searchVersion: function (dataString) {
		var index = dataString.indexOf(this.versionSearchString);
		if (index == -1) return;
		return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	},
	dataBrowser: [
		{
			string: navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			prop: window.opera,
			identity: "Opera"
		},
		{
			string: navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		}
	],
	dataOS : [
		{
			string: navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			string: navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	]

};
BrowserDetect.init();

