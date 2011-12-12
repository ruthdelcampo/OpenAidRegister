module ApplicationHelper
  
  def format_date(date)
    return date.strftime('%m/%d/%Y') if date.present? && date.is_a?(Date)
    date
  end
  
  def format_date_dash(date)
    return date.strftime('%Y-%m-%d') if date.present? && date.is_a?(Date)
    date
  end

  def collaboration_type_by_id(id)
    collaboration_type_list.select{|collaboration_type| collaboration_type.last.to_i == id.to_i}.first.first if id.present?
  end
  
  def collaboration_type_by_name (name)
     collaboration_type_list.select{|collaboration_type| collaboration_type.first == name}.first.last if name.present?
  end
  
  def collaboration_type_list
   [
     ['', ''],
     ['Aid through NGOs', 5],
     ['Aid to NGOs', 6],
     ['Aid through PPPs', 7]
     ]
  end
  
   def aid_type_by_id(id)
       aid_type_list.select{|aid_type| aid_type.last == id}.first.first if id.present?
     end

     def aid_type_by_name (name)
        aid_type_list.select{|aid_type| aid_type.first == name}.first.last if name.present?
     end

     def aid_type_list
       [
         ['', ''],
     			['General budget support','A01'],
     				['Sector budget support','A02'],
     				['Core support to NGOs, other private bodies, PPPs and research institutes','B01'],
     				['Core contributions to multilateral institutions','B02'],
     				['Contributions to specific-purpose programmes and funds managed by international organisations','B03'],
     				['Basket funds/pooled funding','B04'],
     				['Project-type interventions','C01'],
     				['Donor country personnel','D01'],
     				['Other technical assistance','D02'],
     				['Scholarships/training in donor country','E01'],
     				['Imputed student costs','E02'],
     				['Debt relief','F01'],
     				['Administrative costs not included elsewhere','G01'],
     				['Development awareness','H01'],
     				['Refugees in donor countries','H02']
     				]
     end
     
     def tied_status_by_id(id)
         tied_status_list.select{|tied_status| tied_status.last.to_i == id.to_i}.first.first if id.present?
       end

       def tied_status_by_name (name)
          tied_status_list.select{|tied_status| tied_status.first == name}.first.last if name.present?
       end

       def tied_status_list
         [
       		['', ''],
       		['Partially tied', 3],
       		['Tied', 4],
       		['Untied', 5]
       		]
       end
  
     def flow_type_by_id(id)
         flow_type_list.select{|flow_type| flow_type.last.to_i == id.to_i}.first.first if id.present?
       end

       def flow_type_by_name (name)
          flow_type_list.select{|flow_type| flow_type.first == name}.first.last if name.present?
       end

       def flow_type_list
         [
           ['', ''],
     			['Official development assistance (ODA)','10'],
     			['Other official flows (OOF)','20'],
     			['PRIVATE NGO','30'],
     			['	PRIVATE MARKET','35']
     			]
       end
       
       def finance_type_by_id(id)
            finance_type_list.select{|finance_type| finance_type.last.to_i == id.to_i}.first.first if id.present?
          end

          def finance_type_by_name (name)
             finance_type_list.select{|finance_type| finance_type.first == name}.first.last if name.present?
          end

          def finance_type_list
            [
              ['', '']	,
							['Aid grant excluding debt reorganisation','110'],
							['Subsidies to national private investors','111'],
							['Interest subsidy grant in AF','210'],
							['Interest subsidy to national private exporters','211'],
							['Deposit basis','310'],
								['Encashment basis','311'],
								['Aid loan excluding debt reorganisation','410'],
								['Investment-related loan to developing countries','411'],
								['Loan in a joint venture with the recipient','412'],
							['Loan to national private investor','413'],
							['Loan to national private exporter','414'],
							['Non-banks guaranteed export credits','451'],
							['Non-banks non-guaranteed portions of guaranteed export credits','452'],
							['Bank export credits','453'],
							['Acquisition of equity as part of a joint venture with the recipient','510'],
							['Acquisition of equity not part of joint venture in developing countries','511'],
							['Other acquisition of equity','512'],
						['Debt forgiveness: ODA claims (P)','610'],
						['Debt forgiveness: ODA claims (I)','611'],
						['Debt forgiveness: OOF claims (P)','612'],
						['Debt forgiveness: OOF claims (I)','613'],
						['Debt forgiveness: Private claims (P)','614'],
						['Debt forgiveness: Private claims (I)','615'],
						['Debt forgiveness: OOF claims (DSR)','616'],
						['Debt forgiveness: Private claims (DSR)','617'],
						['Debt forgiveness: Other','618'],
						['Debt rescheduling: ODA claims (P)','620'],
						['Debt rescheduling: ODA claims (I)','621'],
						['Debt rescheduling: OOF claims (P)','622'],
						['Debt rescheduling: OOF claims (I)','623'],
						['Debt rescheduling: Private claims (P)','624'],
						['Debt rescheduling: Private claims (I)','625'],
						['Debt rescheduling: OOF claims (DSR)','626'],
						['Debt rescheduling: Private claims (DSR)','627'],
						['Unicode Encode Error','630'],
						['Unicode Encode Error','631'],
						['Unicode Encode Error','632'],
						['Foreign direct investment','710'],
						['Other foreign direct investment, including reinvested earnings','711'],
						['Bank bonds','810'],
						['Non-bank bonds','811'],
						['Other bank securities/claims','910'],
						['Other non-bank securities/claims','911'],
						['Securities and other instruments issued by multilateral agencies','912']
						]
          end
   
     
  
  
  def transaction_type_by_id(id)
    transaction_type_list.select{|transaction_type| transaction_type.last == id}.first.first if id.present?
  end
  
  def transaction_type_by_name (name)
     transaction_type_list.select{|transaction_type| transaction_type.first == name}.first.last if name.present?
  end
  
  def transaction_type_list
    [
    ['Commitment', 'C'],
    ['Disbursement', 'D'],
    ['Expenditure', 'E'],
    ['Incoming Funds', 'IF'],
		['Interest Repayment', 'IR'],
    ['Loan Repayment', 'LR'],
    ['Reimbursement', 'R']
    ]
  end

  def currency_by_id(id)
    currency_list.select{|currency| currency.last == id}.first.first if id.present?
  end
  
  def currency_by_name (name)
     currency_list.select{|currency| currency.first == name}.first.last if name.present?
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
  
  def sector_by_id(id)
    sectors_list.select{|sector| sector.last.to_i == id.to_i}.first.first if id.present?
  end

  def sectors_list
    [
      ['Teacher training',	'2'],
      ['Education facilities and training',	'1'],
      ['Educational research',	'3'],
      ['Primary education',	'4'],
      ['Basic life skills for youth and adults',	'5'],
      ['Early childhood education',	'6'],
      ['Secondary education',	'7'],
      ['Vocational training',	'8'],
      ['Higher education',	'9'],
      ['Advanced technical and managerial training',	'10'],
      ['Health policy and administrative management',	'11'],
      ['Medical education/training',	'12'],
      ['Medical research',	'13'],
      ['Medical services',	'14'],
      ['Basic health care',	'15'],
      ['Basic health infrastructure',	'16'],
      ['Basic nutrition',	'17'],
      ['Infectious disease control',	'18'],
      ['Health education',	'19'],
      ['Malaria control',	'20'],
      ['Tuberculosis control',	'21'],
      ['Health personnel development',	'22'],
      ['Population policy and administrative management',	'23'],
      ['Reproductive health care',	'24'],
      ['Family planning',	'25'],
      ['STD control including HIV/AIDS',	'26'],
      ['Personnel development for population and reproductive health',	'27'],
      ['Water resources policy and administrative management',	'28'],
      ['Water resources protection',	'29'],
      ['Water supply and sanitation - large systems',	'30'],
      ['Basic drinking water supply and basic sanitation',	'31'],
      ['River development',	'32'],
      ['Waste management/disposal',	'33'],
      ['Education and training in water supply and sanitation',	'34'],
      ['Economic and development policy/planning',	'35'],
      ['Public sector financial management',	'36'],
      ['Legal and judicial development',	'37'],
      ['Government administration',	'38'],
      ['Strengthening civil society',	'39'],
      ['Elections',	'40'],
      ['Human rights',	'41'],
      ['Free flow of information',	'42'],
      ['Womens equality organisations and institutions',	'43'],
      ['Security system management and reform',	'44'],
      ['Civilian peace-building, conflict prevention and resolution',	'45'],
      ['Post-conflict peace-building (UN)',	'46'],
      ['Reintegration and SALW control',	'47'],
      ['Land mine clearance',	'48'],
      ['Child soldiers (Prevention and demobilisation)',	'49'],
      ['Social/ welfare services',	'50'],
      ['Employment policy and administrative management',	'51'],
      ['Housing policy and administrative management',	'52'],
      ['Low-cost housing',	'53'],
      ['Multisector aid for basic social services',	'54'],
      ['Culture and recreation',	'55'],
      ['Statistical capacity building',	'56'],
      ['Narcotics control',	'57'],
      ['Social mitigation of HIV/AIDS',	'58'],
      ['Transport policy and administrative management',	'59'],
      ['Road transport',	'60'],
      ['Rail transport',	'61'],
      ['Water transport',	'62'],
      ['Air transport',	'63'],
      ['Storage',	'64'],
      ['Education and training in transport and storage',	'65'],
      ['Communications policy and administrative management',	'66'],
      ['Telecommunications',	'67'],
      ['Radio/television/print media',	'68'],
      ['Information and communication technology (ICT)',	'69'],
      ['Energy policy and administrative management',	'70'],
      ['Power generation/non-renewable sources',	'71'],
      ['Power generation/renewable sources',	'72'],
      ['Electrical transmission/ distribution',	'73'],
      ['Gas distribution',	'74'],
      ['Oil-fired power plants',	'75'],
      ['Gas-fired power plants',	'76'],
      ['Coal-fired power plants',	'77'],
      ['Nuclear power plants',	'78'],
      ['Hydro-electric power plants',	'79'],
      ['Geothermal energy',	'80'],
      ['Solar energy',	'81'],
      ['Wind power',	'82'],
      ['Ocean power',	'83'],
      ['Biomass',	'84'],
      ['Energy education/training',	'85'],
      ['Energy research',	'86'],
      ['Financial policy and administrative management',	'87'],
      ['Monetary institutions',	'88'],
      ['Formal sector financial intermediaries',	'89'],
      ['Informal/semi-formal financial intermediaries',	'90'],
      ['Education/training in banking and financial services',	'91'],
      ['Business support services and institutions',	'92'],
      ['Privatisation',	'93'],
      ['Agricultural policy and administrative management',	'94'],
      ['Agricultural development',	'95'],
      ['Agricultural land resources',	'96'],
      ['Agricultural water resources',	'97'],
      ['Agricultural inputs',	'98'],
      ['Food crop production',	'99'],
      ['Industrial crops/export crops',	'100'],
      ['Livestock',	'101'],
      ['Agrarian reform',	'102'],
      ['Agricultural alternative development',	'103'],
      ['Agricultural extension',	'104'],
      ['Agricultural education/training',	'105'],
      ['Agricultural research',	'106'],
      ['Agricultural services',	'107'],
      ['Plant and post-harvest protection and pest control',	'108'],
      ['Agricultural financial services',	'109'],
      ['Agricultural co-operatives',	'110'],
      ['Livestock/veterinary services',	'111'],
      ['Forestry policy and administrative management',	'112'],
      ['Forestry development',	'113'],
      ['Fuelwood/charcoal',	'114'],
      ['Forestry education/training',	'115'],
      ['Forestry research',	'116'],
      ['Forestry services',	'117'],
      ['Fishing policy and administrative management',	'118'],
      ['Fishery development',	'119'],
      ['Fishery education/training',	'120'],
      ['Fishery research',	'121'],
      ['Fishery services',	'122'],
      ['Industrial policy and administrative management',	'123'],
      ['Industrial development',	'124'],
      ['Small and medium-sized enterprises (SME) development',	'125'],
      ['Cottage industries and handicraft',	'126'],
      ['Agro-industries',	'127'],
      ['Forest industries',	'128'],
      ['Textiles, leather and substitutes',	'129'],
      ['Chemicals',	'130'],
      ['Fertilizer plants',	'131'],
      ['Cement/lime/plaster',	'132'],
      ['Energy manufacturing',	'133'],
      ['Pharmaceutical production',	'134'],
      ['Basic metal industries',	'135'],
      ['Non-ferrous metal industries',	'136'],
      ['Engineering',	'137'],
      ['Transport equipment industry',	'138'],
      ['Technological research and development',	'139'],
      ['Mineral/mining policy and administrative management',	'140'],
      ['Mineral prospection and exploration',	'141'],
      ['Coal',	'142'],
      ['Oil and gas',	'143'],
      ['Ferrous metals',	'144'],
      ['Nonferrous metals',	'145'],
      ['Precious metals/materials',	'146'],
      ['Industrial minerals',	'147'],
      ['Fertilizer minerals',	'148'],
      ['Offshore minerals',	'149'],
      ['Construction policy and administrative management',	'150'],
      ['Trade policy and administrative management',	'151'],
      ['Trade facilitation',	'152'],
      ['Regional trade agreements (RTAs)',	'153'],
      ['Multilateral trade negotiations',	'154'],
      ['Trade-related adjustment',	'155'],
      ['Trade education/training',	'156'],
      ['Tourism policy and administrative management',	'157'],
      ['Environmental policy and administrative management',	'158'],
      ['Biosphere protection',	'159'],
      ['Bio-diversity',	'160'],
      ['Site preservation',	'161'],
      ['Flood prevention/control',	'162'],
      ['Environmental education/ training',	'163'],
      ['Environmental research',	'164'],
      ['Multisector aid',	'165'],
      ['Urban development and management',	'166'],
      ['Rural development',	'167'],
      ['Non-agricultural alternative development',	'168'],
      ['Multisector education/training',	'169'],
      ['Research/scientific institutions',	'170'],
      ['General budget support',	'171'],
      ['Food aid/Food security programmes',	'172'],
      ['Import support (capital goods)',	'173'],
      ['Import support (commodities)',	'174'],
      ['Action relating to debt',	'175'],
      ['Debt forgiveness',	'176'],
      ['Relief of multilateral debt',	'177'],
      ['Rescheduling and refinancing',	'178'],
      ['Debt for development swap',	'179'],
      ['Other debt swap',	'180'],
      ['Debt buy-back',	'181'],
      ['Material relief assistance and services',	'182'],
      ['Emergency food aid',	'183'],
      ['Relief co-ordination; protection and support services',	'184'],
      ['Reconstruction relief and rehabilitation',	'185'],
      ['Disaster prevention and preparedness',	'186'],
      ['Administrative costs',	'187'],
      ['Support to national NGOs',	'188'],
      ['Support to international NGOs',	'189'],
      ['Support to local and regional NGOs',	'190'],
      ['Refugees in donor countries',	'191'],
      ['Sectors not specified',	'192'],
      ['Promotion of development awareness',	'193']
    ]
  end
end
