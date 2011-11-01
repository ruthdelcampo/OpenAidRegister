module ProjectHelper
  def current_geo_level?(detail)
    @reverse_geo.first.level_detail == detail
  end
end
