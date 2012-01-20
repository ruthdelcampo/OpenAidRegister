class ProjectPartnerorganization

  # find Project by id
  #----------------------------------------------------------------------

  def self.by_project_id(project_id)
    sql = "select other_org_name, other_org_role
      from project_partnerorganizations where project_id = ?"
    result = Oar::execute_query(sql, project_id)
    result.try :rows
  end

  def self.by_organization_id_grouped_by_project(organization_id)
    sql = "select project_id,
           array_agg(project_partnerorganizations.other_org_name) AS other_org_names,
           array_agg(project_partnerorganizations.other_org_role) AS other_org_roles
           from project_partnerorganizations
           INNER JOIN projects
           ON project_partnerorganizations.project_id = projects.cartodb_id
           WHERE organization_id = ? GROUP BY project_id"
    result = Oar::execute_query(sql, organization_id)
    result.rows.each do |row|
      row[:other_org_names] = row[:other_org_names][1..-2].split(",")
      row[:other_org_roles] = row[:other_org_roles][1..-2].split(",")
    end
    result.rows
  end

  def self.create(project_id, org_name, org_role)
    sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (?, '?', '?')"
    Oar::execute_query(sql, project_id, org_name, org_role)
  end

  def self.create_many(project_id, organizations)
    if organizations
      organizations.each do |participating_org|
        next if participating_org[:name].blank? || participating_org[:role].blank?
        aux_name = participating_org[:name]
        aux_role = participating_org[:role]
        ProjectPartnerorganization.create(project_id, aux_name, aux_role)
      end
    end
  end

  # DELETE!
  #----------------------------------------------------------------------

  def self.delete_by_project_id(project_id)
    sql = "DELETE FROM project_partnerorganizations where  project_id = '?'"
    Oar::execute_query(sql, project_id)
  end

end
