
$(document).ready(function() {
	var di = $('.box_list');
	var counter = true
	var content1 = $('<ul> <li class="first"><h4><a name="who_is_using_it"></A> WHO IS ALREADY USING THIS</h4><span><img src="/images/ewb_logo.png" alt="" /></span><p class="blockquoto">It is an extremely effective tool for NGOs to publish IATI data. We\'ve found the platform\'s interface easy to navigate and intuitive to use. Partnering with the Open Aid Register is a quick and reliable way for NGOs to contribute to the aid effectiveness movement by becoming IATI compliant.</p></li>'
	+'<li><h4>RECENTLY PUBLISHED PROJECTS</h4><h5>Water Team: Water Point Monitoring</h5><small>EWB Canada<strong>170000 CAD</strong></small>'
	+'<p>Mapping water points is a critical step towards improving clean water access for rural families in Malawi. Using an innovative tool we created to monitor the lifecycle of hand pumps, wells and boreholes, EWB volunteers have documented the location of water points across the country. With this information, we are facilitating improved decision-making for development partners and local government</p>'
	+'<div class="date_sec"><ul><li><span>FROM</span> <strong>2010-11-01</strong> </li><li><span>TO</span> <strong>2011-11-01</strong></li></ul></div></li>'
	+'<li class="last"><h4>&nbsp;</h4><h5>Water Team: Small-business solutions for repair and parts</h5><small>EWB Canada<strong>140000 CAD</strong></small>'
	+'<p>In villages where the majority of water points are broken, access to spare parts and repair training are needed to restore clean sources of water. To make this a reality, EWB is providing knowledge, training, and research support to our partners to develop and pilot a solution to this problem.</p>'
	+'<div class="date_sec"><ul><li><span>FROM</span> <strong>2010-11-01</strong></li><li><span>TO</span> <strong>2011-11-01</strong> </li></ul></div></li></ul>');
	
	var content2 = $('<ul> <li class="first"><h4><a name="who_is_using_it"></A> WHO IS ALREADY USING THIS</h4><span><img src="/images/IndigoLogo.png" alt="" /></span><p class="blockquoto"> Open Aid Register is remarkably quick and easy to use. In fact, the site allowed us to publish a year’s worth of data in a single day. If your NGO or foundation is looking for the best way to become IATI compliant, then you may well just have found it.</p></li>'
	+'<li><h4>LAST PUBLISHED PROJECTS</h4><h5>Wikimedia Mobile</h5><small>Indigo Trust<strong>10000 GBP</strong></small>'
	+'<p>A grant of £10,000 to the Wikimedia Foundation, the non-profit that operates Wikipedia. The money will go toward upgrading Wikimedia’s mobile platform, which will enable Wikimedia to better reach the millions of people in the developing world and low-income communities everywhere, who access the Internet exclusively through mobile phones.</p>'
	+'<div class="date_sec"><ul><li><span>FROM</span> <strong>2011-09-07</strong> </li><li><span>TO</span> <strong>2012-09-06</strong></li></ul></div></li>'
	+'<li class="last"><h4>&nbsp;</h4><h5>Salary Costs and Internet Upgrade</h5><small>Indigo Trust<strong>20000 GBP</strong></small>'
	+'<p>A grant of £20,000 to iLab, a computer lab based in Monrovia that provides access to cutting edge technology, expert IT assistance and a community of like-minded individuals. Indigo\’s grant will be used for staffing costs, the upgrading of iLab\’s internet connection and a small amount for office supply and equipment costs.</p>'
	+'<div class="date_sec"><ul><li><span>FROM</span> <strong>2011-10-05</strong></li><li><span>TO</span> <strong>2012-10-04</strong> </li></ul></div></li></ul>');
	
	var refreshId = setInterval(function()
	{
		if (counter){
		di.empty();
		di.append(content2);	
		}else{
		di.empty();
		di.append(content1);
		}
		counter = !counter
	}, 3000);
		

});