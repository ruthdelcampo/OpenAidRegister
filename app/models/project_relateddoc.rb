class ProjectRelateddoc

  # find Project by id
  #----------------------------------------------------------------------

  def self.by_project_id(id)
    sql = "select doc_url, doc_type
        from project_relateddocs where project_id = ?"
    result = Oar::execute_query(sql, id)
    result.try :rows
  end

  def self.by_organization_id(organization_id)
    sql = "select project_id, doc_url, doc_type
           from project_relateddocs
           INNER JOIN projects ON project_relateddocs.project_id = projects.cartodb_id
           WHERE organization_id = ?"
    result = Oar::execute_query(sql, organization_id)
    result.rows
  end

  # create one
  #----------------------------------------------------------------------

  def self.create(project_id, doc_url, doc_type)
    sql = "INSERT INTO project_relateddocs (project_id, doc_url, doc_type) VALUES (?, '?', '?')"
    Oar::execute_query(sql, project_id, doc_url, doc_type)
  end

  # create many
  #----------------------------------------------------------------------

  def self.create_many(project_id, related_docs)
    if related_docs
      related_docs.each do |related_doc|
        next if related_doc[:doc_url].blank? || related_doc[:doc_type].blank?
        ProjectRelateddoc.create(project_id, related_doc[:doc_url], related_doc[:doc_type])
      end
    end
  end

  # DELETE!
  #----------------------------------------------------------------------

  def self.delete_by_project_id(project_id)
    sql = "DELETE FROM project_relateddocs where  project_id = '?'"
    Oar::execute_query(sql, project_id)
  end

end
