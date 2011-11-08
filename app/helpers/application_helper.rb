module ApplicationHelper
  
  def format_date(date)
    return date.strftime('%m/%d/%Y') if date.present? && date.is_a?(Date)
    date
  end
  
  def format_date_dash(date)
    return date.strftime('%m-%d-%Y') if date.present? && date.is_a?(Date)
    date
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
