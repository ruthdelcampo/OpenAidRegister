module ProjectHelper
  def current_geo_level?(detail)
    selected = @project_data[:reverse_geo].first[:level_detail] == detail if @project_data && @project_data[:reverse_geo].present?
    selected = true if detail == 'city' && !selected && !current_geo_level?('country') && !current_geo_level?('region') && !current_geo_level?('lat_lng')
    selected
  end
  
  
end
