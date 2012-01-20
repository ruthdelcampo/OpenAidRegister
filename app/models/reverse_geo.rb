class ReverseGeo

  # find Project by id
  #----------------------------------------------------------------------

  def self.by_project_id(id)
    sql = "select (ST_X(the_geom) || ' ' || ST_Y(the_geom)) AS latlng, adm1, adm2, country, country_extended, level_detail
      from reverse_geo where project_id = ?"
    result = Oar::execute_query(sql, id)
    result.try :rows
  end

  def self.by_organization_id(organization_id)
    sql = "select project_id, level_detail, (ST_X(reverse_geo.the_geom) || ' ' || ST_Y(reverse_geo.the_geom)) AS latlng, country_extended,
           country, adm1, adm2 from reverse_geo
           INNER JOIN projects ON reverse_geo.project_id = projects.cartodb_id
           WHERE organization_id = ? "
    result = Oar::execute_query(sql, organization_id)
    result.rows
  end

  # create one
  #----------------------------------------------------------------------

  def self.create(project_id, geo)
    sql = "INSERT INTO reverse_geo (project_id, the_geom, adm1, adm2, country, country_extended, level_detail) VALUES (
             ?,
             ST_GeomFromText('POINT(?)',4326),
             '?',
             '?',
             '?',
             '?',
             '?'
           )"
    Oar::execute_query(sql, project_id,
                       geo[:latlng],
                       geo[:adm1],
                       geo[:adm2],
                       geo[:country],
                       geo[:country_extended],
                       geo[:level_detail])
  end

  # create many
  #----------------------------------------------------------------------

  def self.create_many(project_id, reverse_geo)
    if reverse_geo
      reverse_geo.each do |geo|
        next if geo[:latlng].blank? || geo[:country].blank? || geo[:level_detail].blank?
        ReverseGeo.create(project_id, geo)
      end
    end
  end


  # DELETE!
  #----------------------------------------------------------------------

  def self.delete_by_project_id(project_id)
    sql = "DELETE FROM reverse_geo where  project_id = '?'"
    Oar::execute_query(sql, project_id)
  end


end
