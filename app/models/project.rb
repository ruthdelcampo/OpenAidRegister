class Project

  PRIMARY_KEY = "cartodb_id"
  ATTRIBUTES = [
                "aid_type",
                "budget",
                "budget_currency",
                "collaboration_type",
                "contact_email",
                "contact_name",
                "created_at",
                "description",
                "end_date",
                "finance_type",
                "flow_type",
                "language",
                "org_role",
                "organization_id",
                "other_iati_project_identifier",
                "program_guid",
                "project_guid",
                "result_description",
                "result_title",
                "start_date",
                "tied_status",
                "title",
                "updated_at",
                "website",
               ]

  ATTRS_WITH_KEY = ATTRIBUTES.push PRIMARY_KEY

  # find Project by id
  #----------------------------------------------------------------------

  def self.find(id, organization_id=nil)
    if organization_id
      sql = "SELECT #{ATTRS_WITH_KEY.join(',')} FROM projects WHERE cartodb_id = ? AND organization_id = ?"
      result = Oar::execute_query(sql, id, organization_id)
    else
      sql = "select #{ATTRS_WITH_KEY.join(',')} FROM projects WHERE cartodb_id = ?"
      result = Oar::execute_query(sql, id)
    end
    result.rows.first
  end

  # find all the projects from the given organization
  #----------------------------------------------------------------------

  def self.by_organization_id(organization_id)
    sql = "SELECT #{ATTRS_WITH_KEY.join(',')} FROM projects WHERE organization_id = ?"
    result = Oar::execute_query(sql, organization_id)
    result.rows
  end

  # find the last project by organization_id
  #----------------------------------------------------------------------
  def self.last_by_organization_id(organization_id)
    sql = "SELECT #{ATTRS_WITH_KEY.join(',')} from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1"
    result = Oar::execute_query(sql, organization_id)
    result.rows.first
  end

  # CREATE A PROJECT
  #----------------------------------------------------------------------

  def self.create(params, organization_id, start_date, end_date)
    # create the project
    sql="INSERT INTO PROJECTS (organization_id, title, description, org_role, language,
         project_guid, start_date, end_date, budget, budget_currency, website,
         program_guid, result_title, result_description, collaboration_type,
         tied_status, aid_type, flow_type, finance_type, contact_name, contact_email, other_iati_project_identifier) VALUES
                 (?, '?', '?','?',
                 '?',
                 '?', ?, ?, '?',
                 '?', '?', '?', '?',
                 '?',
                 '?','?',
                 '?',
                 '?','?',
                 '?',
                 '?','?')"
    Oar::execute_query(sql, organization_id,
                       params[:title],
                       params[:description],
                       params[:org_role],
                       params[:language],
                       params[:project_guid],
                       start_date,
                       end_date,
                       params[:budget],
                       params[:budget_currency],
                       params[:website],
                       params[:program_guid],
                       params[:result_title],
                       params[:result_description],
                       params[:collaboration_type],
                       params[:tied_status],
                       params[:aid_type],
                       params[:flow_type],
                       params[:finance_type],
                       params[:contact_name],
                       params[:contact_email],
                       params[:other_iati_project_identifier])

    # return the new project
    Project.last_by_organization_id(organization_id)
  end

  # UPDATE A PROJECT
  #----------------------------------------------------------------------

  def self.update(project_id, params, start_date, end_date)
    #it is an existing project do whatever
    sql="UPDATE projects SET title='?', description ='?', org_role ='?',
    language= '?', project_guid='?', start_date=?, end_date=?, budget='?', budget_currency='?',
     website='?', program_guid = '?', result_title='?',
     result_description='?', collaboration_type='?',tied_status ='?',
     aid_type ='?', flow_type ='?',
     finance_type ='?',contact_name='?', contact_email='?',
     other_iati_project_identifier='?' WHERE cartodb_id='?'"

    Oar::execute_query(sql,
                  params[:title],
                  params[:description],
                  params[:org_role],
                  params[:language],
                  params[:project_guid],
                  start_date,
                  end_date,
                  params[:budget],
                  params[:budget_currency],
                  params[:website],
                  params[:program_guid],
                  params[:result_title],
                  params[:result_description],
                  params[:collaboration_type],
                  params[:tied_status],
                  params[:aid_type],
                  params[:flow_type],
                  params[:finance_type],
                  params[:contact_name],
                  params[:contact_email],
                  params[:other_iati_project_identifier],
                  project_id)

  end


  # DELETE A PROJECT AND ALL THE RELATED DATA
  #----------------------------------------------------------------------

  def self.destroy(project_id)
    sql = "delete FROM projects where projects.cartodb_id = '?'"
    Oar::execute_query(sql, project_id)
    sql = "delete FROM project_sectors where project_id = '?'"
    Oar::execute_query(sql, project_id)
    sql = "delete FROM project_partnerorganizations where project_id = '?'"
    Oar::execute_query(sql, project_id)
    sql = "delete FROM project_relateddocs where project_id = '?'"
    Oar::execute_query(sql, project_id)
    sql = "delete FROM project_transactions where project_id = '?'"
    Oar::execute_query(sql, project_id)
    sql = "delete FROM reverse_geo where project_id = '?'"
    Oar::execute_query(sql, project_id)
  end

end
