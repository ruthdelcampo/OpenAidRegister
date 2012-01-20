class ProjectTransaction

  # find Project by id
  #----------------------------------------------------------------------

  def self.by_project_id(id)
    sql = "select transaction_type, transaction_value, transaction_currency, transaction_date, provider_activity_id,
        provider_name, provider_id, receiver_activity_id, receiver_name, receiver_id, transaction_description
      from project_transactions where project_id = ?"
    result = Oar::execute_query(sql, id)
    result.try :rows
  end

  def self.by_organization_id(organization_id)
    sql = "select project_id, transaction_type, transaction_value, transaction_currency,
           transaction_date, provider_activity_id, provider_name, provider_id,
           receiver_activity_id, receiver_name, receiver_id, transaction_description
           from project_transactions
           INNER JOIN projects ON project_transactions.project_id = projects.cartodb_id
           WHERE organization_id = ?"
    result = Oar::execute_query(sql, organization_id)
    result.rows
  end

  # create one
  #----------------------------------------------------------------------

  def self.create(project_id, transaction)
    sql = "INSERT INTO project_transactions (project_id, transaction_type,
                   transaction_value, transaction_currency, transaction_date,
                   provider_activity_id, provider_name, provider_id, receiver_activity_id,
                   receiver_name, receiver_id, transaction_description)
                   VALUES (?, '?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?')"
    Oar::execute_query(sql, project_id, transaction[:transaction_type],
                       transaction[:transaction_value], transaction[:transaction_currency],
                       transaction[:transaction_date], transaction[:provider_activity_id],
                       transaction[:provider_name], transaction[:provider_id],
                       transaction[:receiver_activity_id], transaction[:receiver_name],
                       transaction[:receiver_id], transaction[:transaction_description])
  end

  # create many
  #----------------------------------------------------------------------

  def self.create_many(project_id, transactions)
    if transactions
      transactions.each do |transaction|
        next if transaction[:transaction_type].blank? ||
          transaction[:transaction_value].blank? ||
          transaction[:transaction_date].blank?

        ProjectTransaction.create(project_id, transaction)
      end
    end
  end

  # DELETE!
  #----------------------------------------------------------------------

  def self.delete_by_project_id(project_id)
    sql = "DELETE FROM project_transactions where  project_id = '?'"
    Oar::execute_query(sql, project_id)
  end

end
