class ProjectSector

  # find Project Sector by id
  #----------------------------------------------------------------------

  def self.find(id)
    sql = 'select cartodb_id, project_id, sector_id, the_geom_str
           FROM project_sectors WHERE cartodb_id = ?'

    result = Oar::execute_query(sql, id)
    result.rows.first
  end

  def self.create(project_id, sector_id)
    sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (?, ?)"
    Oar::execute_query(sql, project_id, sector_id)
  end

  def self.create_many(project_id, sectors)
    if sectors
      sectors.each do |sector|
        ProjectSector.create(project_id, sector[:id])
      end
    end
  end

  # Returns an array of sector ids that belongs to the given project
  #
  # @param [Integer] the project_id
  # @return [Array] array of sector ids
  #----------------------------------------------------------------------

  def self.ids_where_project_id(project_id)
    sql = "select array_agg(sector_id) from project_sectors where project_id = ?"

    result = Oar::execute_query(sql, project_id)
    first_row = result.rows.first
    if first_row[:array_agg]
      eval("[#{first_row[:array_agg][1..-2]}]")
    else
      []
    end
  end

  # Returns an array of hashes with the key ":id" and the value == the sector_id
  # these sectors belongs to the given project
  #
  # @param [Integer] the project_id
  # @return [Array] array of hashes of the form {:id => sector_id}
  #----------------------------------------------------------------------

  def self.kv_ids_where_project_id(project_id)
    sql = "select sector_id as id from project_sectors where project_id = ?"

    result = Oar::execute_query(sql, project_id)
    result.try :rows
  end


  # DELETE!
  #----------------------------------------------------------------------

  def self.delete_by_project_id(project_id)
    sql = "DELETE FROM project_sectors where  project_id = '?'"
    Oar::execute_query(sql, project_id)
  end

end
