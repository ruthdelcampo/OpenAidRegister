class Organization

  # find Organization by id
  #----------------------------------------------------------------------

  def self.find(id)
    sql="SELECT is_validated, organization_country, organization_guid,
    organization_name, organization_type_id
    FROM organizations WHERE cartodb_id = ?"
    result = Oar::execute_query(sql, id)
    result.rows.first
  end


end
