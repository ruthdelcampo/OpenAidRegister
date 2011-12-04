module ProjectHelper
  def current_geo_level?(detail)
    selected = @project_data[:reverse_geo].first[:level_detail] == detail if @project_data && @project_data[:reverse_geo].present?
    selected = true if detail == 'city' && !selected && !current_geo_level?('country') && !current_geo_level?('region') && !current_geo_level?('lat_lng')
    selected
  end
  
  def currency_list
     [
     ['',''],
 		['Afghani','AFN'],
 		['UAE Dirham','AED'],
 		['Lek','ALL'],
 		['Armenian Dram','AMD'],
 		['Netherlands Antillian Guilder','ANG'],
 		['Kwanza','AOA'],
 		['Argentine Peso','ARS'],
 		['Australian Dollar','AUD'],
 		['Aruban Guilder','AWG'],
 		['Azerbaijanian Manat','AZN'],
 		['Convertible Marks','BAM'],
 		['Barbados Dollar','BBD'],
 		['Taka','BDT'],
 		['Bulgarian Lev','BGN'],
 		['Bahraini Dinar','BHD'],
 		['Burundi Franc','BIF'],
 		['Bermudian Dollar','BMD'],
 		['Brunei Dollar','BND'],
 		['Boliviano','BOB'],
 		['Mvdol','BOV'],
 		['Brazilian Real','BRL'],
 		['Bahamian Dollar','BSD'],
 		['Ngultrum','BTN'],
 		['Pula','BWP'],
 		['Belarussian Ruble','BYR'],
 		['Belize Dollar','BZD'],
 		['Canadian Dollar','CAD'],
 		['Congolese Franc','CDF'],
 		['Swiss Franc','CHF'],
 		['Unidades de fomento','CLF'],
 		['Chilean Peso','CLP'],
 		['Yuan Renminbi','CNY'],
 		['Colombian Peso','COP'],
 		['Unidad de Valor Real','COU'],
 		['Costa Rican Colon','CRC'],
 		['Peso Convertible','CUC'],
 		['Cuban Peso','CUP'],
 		['Cape Verde Escudo','CVE'],
 		['Czech Koruna','CZK'],
 		['Djibouti Franc','DJF'],
 		['Danish Krone','DKK'],
 		['Dominican Peso','DOP'],
 		['Algerian Dinar','DZD'],
 		['Kroon','EEK'],
 		['Egyptian Pound','EGP'],
 		['Nakfa','ERN'],
 		['Ethiopian Birr','ETB'],
 		['Euro','EUR'],
 		['Fiji Dollar','FJD'],
 		['Falkland Islands Pound','FKP'],
 		['Pound Sterling','GBP'],
 		['Lari','GEL'],
 		['Cedi','GHS'],
 		['Gibraltar Pound','GIP'],
 		['Dalasi','GMD'],
 		['Guinea Franc','GNF'],
 		['Quetzal','GTQ'],
 		['Guyana Dollar','GYD'],
 		['Hong Kong Dollar','HKD'],
 		['Lempira','HNL'],
 		['Croatian Kuna','HRK'],
 		['Gourde','HTG'],
 		['Forint','HUF'],
 		['Rupiah','IDR'],
 		['New Israeli Sheqel','ILS'],
 		['Indian Rupee','INR'],
 		['Iraqi Dinar','IQD'],
 		['Iranian Rial','IRR'],
 		['Iceland Krona','ISK'],
 		['Jamaican Dollar','JMD'],
 		['Jordanian Dinar','JOD'],
 		['Yen','JPY'],
 		['Kenyan Shilling','KES'],
 		['Som','KGS'],
 		['Riel','KHR'],
 		['Comoro Franc','KMF'],
 		['North Korean Won','KPW'],
 		['Won','KRW'],
 		['Kuwaiti Dinar','KWD'],
 		['Cayman Islands Dollar','KYD'],
 		['Tenge','KZT'],
 		['Kip','LAK'],
 		['Lebanese Pound','LBP'],
 		['Sri Lanka Rupee','LKR'],
 		['Liberian Dollar','LRD'],
 		['Loti','LSL'],
 		['Lithuanian Litas','LTL'],
 		['Latvian Lats','LVL'],
 		['Libyan Dinar','LYD'],
 		['Moroccan Dirham','MAD'],
 		['Moldovan Leu','MDL'],
 		['Malagasy Ariary','MGA'],
 		['Denar','MKD'],
 		['Kyat','MMK'],
 		['Tugrik','MNT'],
 		['Pataca','MOP'],
 		['Ouguiya','MRO'],
 		['Mauritius Rupee','MUR'],
 		['Rufiyaa','MVR'],
 		['Malawi Kwacha','MWK'],
 		['Mexican Peso','MXN'],
 		['Mexican Unidad de Inversion (UDI)','MXV'],
 		['Malaysian Ringgit','MYR'],
 		['Metical','MZN'],
 		['Namibia Dollar','NAD'],
 		['Naira','NGN'],
 		['Cordoba Oro','NIO'],
 		['Norwegian Krone','NOK'],
 		['Nepalese Rupee','NPR'],
 		['New Zealand Dollar','NZD'],
 		['Rial Omani','OMR'],
 		['Balboa','PAB'],
 		['Nuevo Sol','PEN'],
 		['Kina','PGK'],
 		['Philippine Peso','PHP'],
 		['Pakistan Rupee','PKR'],
 		['Zloty','PLN'],
 		['Guarani','PYG'],
 		['Qatari Rial','QAR'],
 		['New Leu','RON'],
 		['Serbian Dinar','RSD'],
 		['Russian Ruble','RUB'],
 		['Rwanda Franc','RWF'],
 		['Saudi Riyal','SAR'],
 		['Solomon Islands Dollar','SBD'],
 		['Seychelles Rupee','SCR'],
 		['Sudanese Pound','SDG'],
 		['Swedish Krona','SEK'],
 		['Singapore Dollar','SGD'],
 		['Saint Helena Pound','SHP'],
 		['Leone','SLL'],
 		['Somali Shilling','SOS'],
 		['Surinam Dollar','SRD'],
 		['Dobra','STD'],
 		['El Salvador Colon','SVC'],
 		['Syrian Pound','SYP'],
 		['Lilangeni','SZL'],
 		['Baht','THB'],
 		['Somoni','TJS'],
 		['Manat','TMT'],
 		['Tunisian Dinar','TND'],
 		['Paanga','TOP'],
 		['Turkish Lira','TRY'],
 		['Trinidad and Tobago Dollar','TTD'],
 		['New Taiwan Dollar','TWD'],
 		['Tanzanian Shilling','TZS'],
 		['Hryvnia','UAH'],
 		['Uganda Shilling','UGX'],
 		['US Dollar','USD'],
 		['US Dollar (Next day)','USN'],
 		['US Dollar (Same day)','USS'],
 		['Uruguay Peso en Unidades Indexadas','UYI'],
 		['Peso Uruguayo','UYU'],
 		['Uzbekistan Sum','UZS'],
 		['Bolivar Fuerte','VEF'],
 		['Dong','VND'],
 		['Vatu','VUV'],
 		['Tala','WST'],
 		['CFA Franc BEAC','XAF'],
 		['East Caribbean Dollar','XCD'],
 		['CFA Franc BCEAO','XOF'],
 		['CFP Franc','XPF'],
 		['Yemeni Rial','YER'],
 		['Rand','ZAR'],
 		['Zambian Kwacha','ZMK'],
 		['Zimbabwe Dollar','ZWL']
 	  ]
   end
end
