class ProjectController < ApplicationController


  def show #Working partially except other organizations and review date parameters

    if session[:organization].blank?
      session[:return_to] = request.request_uri
      redirect_to '/login'
      return
    end

    #We need to initialize the hash
    @errors = []
    @latlng = []

    @project_data = {}

    # CREATE or UPDATE
    #----------------------------------------------------------------------

    if request.post? #the form comes with the params

      # VALIDATE PARAMS
      #----------------------------------------------------------------------

      @project_data = params  #this works when it is a new project or a existing one

      if params[:title].blank?
        @errors.push("You need to enter a project title")
      end

      if params[:budget].present?
        if !Oar::is_a_number?(params[:budget])
          @errors.push("Budget must be written in numbers")
        end
        if params[:budget_currency].eql?("1")
          @errors.push("You need to select a currency")
        end
      end

      if params[:project_guid].blank?
        @errors.push("You need to enter a project id")
      end

      if params[:org_role].blank?
        @errors.push("You need to select what is you organization's role in this project")
      end


      # check that the project id is unique for this user
      sql = "SELECT cartodb_id, project_guid FROM projects WHERE organization_id = '?'"
      result = execute_query(sql, session[:organization].cartodb_id)
      result.rows.each do |project|
        # check if there is no repeted cartodb_id but only when it is updating project
        if params[:project_guid] == project.project_guid && params[:cartodb_id] != project.cartodb_id.to_s
          @errors.push("Please change the project id. You have already one project with this id")
        end
      end

      # Check if the day is not correct
      # for instance when there is an end date but not a start date
      if !(params[:end_date] =="") && (params[:start_date]=="")
        @errors.push("You need to have a start date when you have introduced and end date")
      end
      # End date cant be earlier as the start date
      if params[:end_date].present? && params[:start_date].present?
        month, day, year = *params[:start_date].split('/').map(&:to_i)
        start_date = Date.new(year, month, day)
        month, day, year = *params[:end_date].split('/').map(&:to_i)
        end_date = Date.new(year, month, day)

        @errors.push("The end date must be later than the start date") if start_date > end_date
      end

      # it is a permanent project
      if params[:start_date].present? && (params[:end_date] =="")
        month, day, year = *params[:start_date].split('/').map(&:to_i)
        start_date = Date.new(year, month, day)
      end

      if params[:contact_email].present? && !match_email(params[:contact_email])
        @errors.push("The format of the contact email is wrong")
      end

      # there has been errors print them on the template AND EXIT
      if @errors.count > 0
        render :template => '/project/show'
        return
      end

      # Prepare the date to be inserted in CartoDB
      start_date = "null" if params[:start_date].blank?
      end_date   = "null" if params[:end_date].blank?

      # prepare the project id. Take out all possible spaces and transform them to
      params[:project_guid] = params[:project_guid].tr(" ", "-")

      # no errors,introduce the data in CartoDB
      # CREATE
      #----------------------------------------------------------------------
      if params[:cartodb_id].blank?

        # It is a new project, save to cartodb
        sql="INSERT INTO PROJECTS (organization_id, title, description, org_role, language,
               project_guid, start_date, end_date, budget, budget_currency, website,
               program_guid, result_title, result_description, collaboration_type, tied_status,
               aid_type, flow_type, finance_type, contact_name, contact_email) VALUES
                 (?, '?', '?','?',
                 '?',
                 '?', ?, ?, '?',
                 '?', '?', '?', '?',
                 '?',
                 '?','?',
                 '?',
                 '?','?',
                 '?',
                 '?')"
        execute_query(sql,
                      session[:organization].cartodb_id,
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
                      params[:contact_email])

        # Now sectors must be written
        if params[:sectors]
          sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1 "
          result = execute_query(sql, session[:organization].cartodb_id)
          params[:sectors].each do |sector|
            sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (?, ?)"
            execute_query(sql, result.rows.first[:cartodb_id], sector[:id])
          end
        end

        # Participating orgs
        if params[:participating_orgs].present?
          # Get the new cartodb_id because the project is new
          sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1 "
          result = execute_query(sql, session[:organization].cartodb_id)

          other_participating_orgs = params[:participating_orgs]
          other_participating_orgs.each do |participating_org|
            next if participating_org[:name].blank? || participating_org[:role].blank?
            aux_name = participating_org[:name]
            aux_role = participating_org[:role]

            # insert organization
            sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (?, '?', '?')"
            execute_query(sql, result.rows.first[:cartodb_id], aux_name, aux_role)
          end
        end

        # transaction_list
        if params[:transaction_list].present?
          #Get the new cartodb_id because the project is new
          sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1 "
          result = execute_query(sql, session[:organization].cartodb_id)

          transaction_list = params[:transaction_list]
          transaction_list.each do |transaction|
            next if transaction[:transaction_type].blank? ||
              transaction[:transaction_value].blank? ||
              transaction[:transaction_date].blank?

            aux_transaction_type = transaction[:transaction_type]
            aux_transaction_value = transaction[:transaction_value]
            aux_transaction_currency = transaction[:transaction_currency]
            aux_transaction_date = transaction[:transaction_date]
            aux_provider_activity_id = transaction[:provider_activity_id]
            aux_provider_name = transaction[:provider_name]
            aux_provider_id = transaction[:provider_id]
            aux_receiver_activity_id = transaction[:receiver_activity_id]
            aux_receiver_name = transaction[:receiver_name]
            aux_receiver_id = transaction[:receiver_id]
            aux_transaction_description = transaction[:transaction_description]

            #insert organization
            sql = "INSERT INTO project_transactions (project_id, transaction_type,
                     transaction_value, transaction_currency, transaction_date,
                     provider_activity_id, provider_name, provider_id, receiver_activity_id,
                     receiver_name, receiver_id, transaction_description)
                     VALUES (?, '?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?')"
            execute_query(sql, result.rows.first[:cartodb_id], aux_transaction_type,
                          aux_transaction_value, aux_transaction_currency,
                          aux_transaction_date, aux_provider_activity_id,
                          aux_provider_name, aux_provider_id, aux_receiver_activity_id,
                          aux_receiver_name, aux_receiver_id, aux_transaction_description)
          end
        end

        # Related docs
        if params[:related_docs].present?
          # Get the new cartodb_id because the project is new
          sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1 "
          result = execute_query(sql, session[:organization].cartodb_id)

          related_docs = params[:related_docs]
          related_docs.each do |related_doc|
            next if related_doc[:doc_url].blank? || related_doc[:doc_type].blank?

            sql = "INSERT INTO project_relateddocs (project_id, doc_url, doc_type) VALUES (?, '?', '?')"
            execute_query(sql, result.rows.first[:cartodb_id], related_doc[:doc_url], related_doc[:doc_type])
          end
        end

        if params[:reverse_geo].present?
          # Get the new cartodb_id because the project is new
          sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=? ORDER BY cartodb_id DESC LIMIT 1 "
          result = execute_query(sql, session[:organization].cartodb_id)

          reverse_geo = params[:reverse_geo]
          reverse_geo.each do |geo|
            next if geo[:latlng].blank? || geo[:country].blank? || geo[:level_detail].blank?
            latlng             = geo[:latlng]
            adm1               = geo[:adm1]
            adm2               = geo[:adm2]
            country            = geo[:country]
            country_extended   = geo[:country_extended]
            level_detail = geo[:level_detail]

            # insert organization
            sql = "INSERT INTO reverse_geo (project_id, the_geom, adm1, adm2, country, country_extended, level_detail) VALUES (
               ?,
               ST_GeomFromText('POINT(?)',4326),
               '?',
               '?',
               '?',
               '?',
               '?'
             )"
            execute_query(sql, result.rows.first[:cartodb_id], latlng, adm1, adm2, country, country_extended, level_detail)
          end
        end


      # UPDATE
      #----------------------------------------------------------------------
      else
        #it is an existing project do whatever
        sql="UPDATE projects SET title='?', description ='?', org_role ='?',
        language= '?', project_guid='?', start_date=?, end_date=?, budget='?', budget_currency='?',
         website='?', program_guid = '?', result_title='?',
         result_description='?', collaboration_type='?',tied_status ='?',
         aid_type ='?', flow_type ='?',
         finance_type ='?',contact_name='?', contact_email='?' WHERE cartodb_id='?'"

        execute_query(sql,
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
                      params[:cartodb_id])

        # In this case, first delete all sectors and overwrite them
        sql = "DELETE FROM project_sectors where  project_id = '?'"
        execute_query(sql, params[:cartodb_id])
        if params[:sectors]
          params[:sectors].each do |sector|
            sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (?, ?)"
            execute_query(sql, params[:cartodb_id], sector[:id])
          end
        end

        # In this case, first delete all partner organizations and overwrite them.
        sql = "DELETE FROM project_partnerorganizations where  project_id = '?'"
        execute_query(sql, params[:cartodb_id])

        if params[:participating_orgs].present?

          other_participating_orgs = params[:participating_orgs]
          other_participating_orgs.each do |participating_org|
            next if participating_org[:name].blank? || participating_org[:role].blank?
            aux_name = participating_org[:name]
            aux_role = participating_org[:role]

            # insert organization
            sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (?, '?', '?')"
            execute_query(sql, params[:cartodb_id], aux_name, aux_role)
          end
        end

        # In this case, first delete all partner organizations and overwrite them.
        # TODO WHERE IS THE TRANSACTION_DATE ??????
        # IT IS USED IN A SIMILAR QUERY BUT IS MISSING HERE
        sql = "DELETE FROM project_transactions where  project_id = '?'"
        execute_query(sql, params[:cartodb_id])

        if params[:transaction_list].present?
          transaction_list = params[:transaction_list]
          transaction_list.each do |transaction|
            next if transaction[:transaction_type].blank? || transaction[:transaction_value].blank?
            aux_transaction_type = transaction[:transaction_type]
            aux_transaction_value = transaction[:transaction_value]
            aux_transaction_currency = transaction[:transaction_currency]
            aux_transaction_date = transaction[:transaction_date]
            aux_provider_activity_id = transaction[:provider_activity_id]
            aux_provider_name = transaction[:provider_name]
            aux_provider_id = transaction[:provider_id]
            aux_receiver_activity_id = transaction[:receiver_activity_id]
            aux_receiver_name = transaction[:receiver_name]
            aux_receiver_id = transaction[:receiver_id]
            aux_transaction_description = transaction[:transaction_description]

            # insert organization
            sql = "INSERT INTO project_transactions (project_id, transaction_type, transaction_value,
                    transaction_currency, transaction_date, provider_activity_id,
                    provider_name, provider_id, receiver_activity_id, receiver_name, receiver_id, transaction_description)
                    VALUES (?, '?', '?', '?', '?', '?', '?', '?', '?', '?', '?', '?')"
            execute_query(sql,
                          params[:cartodb_id],
                          aux_transaction_type,
                          aux_transaction_value,
                          aux_transaction_currency,
                          aux_transaction_date,
                          aux_provider_activity_id,
                          aux_provider_name,
                          aux_provider_id,
                          aux_receiver_activity_id,
                          aux_receiver_name,
                          aux_receiver_id,
                          aux_transaction_description)

          end
        end

        # In this case, first delete all related docs and overwrite them.
        sql = "DELETE FROM project_relateddocs where  project_id = '?'"
        execute_query(sql, params[:cartodb_id])

        if params[:related_docs].present?
          related_docs = params[:related_docs]
          related_docs.each do |related_doc|
            next if related_doc[:doc_url].blank? || related_doc[:doc_type].blank?
            #insert organization
            sql = "INSERT INTO project_relateddocs (project_id, doc_url, doc_type) VALUES (?, '?', '?')"
            execute_query(sql, params[:cartodb_id], related_doc[:doc_url], related_doc[:doc_type])
          end
        end


        # In this case, first delete all geo organizations and overwrite them.
        sql = "DELETE FROM reverse_geo where  project_id = '?'"
        execute_query(sql, params[:cartodb_id])

        if params[:reverse_geo].present?
          reverse_geo = params[:reverse_geo]
          reverse_geo.each do |geo|
            next if geo[:latlng].blank? || geo[:country].blank? || geo[:level_detail].blank?
            latlng       = geo[:latlng]
            adm1         = geo[:adm1]
            adm2         = geo[:adm2]
            country      = geo[:country]
            country_extended = geo[:country_extended]
            level_detail = geo[:level_detail]

            # insert organization
            sql = "INSERT INTO reverse_geo (project_id, the_geom, adm1, adm2, country, country_extended, level_detail) VALUES (
               ?,
               ST_GeomFromText('POINT(?)',4326),
               '?',
               '?',
               '?',
               '?',
               '?'
             )"
            execute_query(sql,
                          params[:cartodb_id],
                          latlng,
                          adm1,
                          adm2,
                          country,
                          country_extended,
                          level_detail)
          end
        end
      end

      # redirect to dash if success
      redirect_to '/dashboard'
      return
    end


    # it is a GET method
    # EDIT
    #----------------------------------------------------------------------
    if params[:id] # it is an existing project select everything from projects and from project_sectors

      sql='select cartodb_id, organization_id, title, description, org_role, language, project_guid, start_date,
        end_date, budget, budget_currency, website, program_guid, result_title,
               result_description, collaboration_type, tied_status, aid_type, flow_type,
               finance_type, contact_name, contact_email
               FROM projects WHERE cartodb_id = ?'

      result = execute_query(sql, params[:id])
      @project_data = result.rows.first

      # select sectors and form the array
      sql = "select array_agg(sector_id) from project_sectors where project_id = ?"
      result = execute_query(sql, params[:id])

      if !result.rows.first[:array_agg].blank?
        @project_data[:sector_id] = eval('['+result.rows.first[:array_agg][1..-2]+']')
      end

      sql = "select sector_id as id from project_sectors where project_id = ?"
      result = execute_query(sql, params[:id])

      @project_data[:sectors] = result.try(:rows)

      # Select partner organizations and form the array
      sql = "select other_org_name, other_org_role
      from project_partnerorganizations where project_id = ?"
      result = execute_query(sql, params[:id])

      @participating_orgs = result.try(:rows)

      # geo data
      sql = "select (ST_X(the_geom) || ' ' || ST_Y(the_geom)) AS latlng, adm1, adm2, country, country_extended, level_detail
      from reverse_geo where project_id = ?"
      result = execute_query(sql, params[:id])

      @project_data[:reverse_geo] = result.try(:rows)
      # @reverse_geo will be used for painting the points in the map with jquery
      (@project_data[:reverse_geo] || []).each_with_index do |row, index|
        @latlng[index]= row[:latlng]
      end

      # transactions
      # Select partner organizations and form the array
      sql = "select transaction_type, transaction_value, transaction_currency, transaction_date, provider_activity_id,
        provider_name, provider_id, receiver_activity_id, receiver_name, receiver_id, transaction_description
      from project_transactions where project_id = ?"
      result = execute_query(sql, params[:id])

      @project_data[:transaction_list] = result.try(:rows)

      # related docs
      sql = "select doc_url, doc_type
        from project_relateddocs where project_id = ?"
      result = execute_query(sql, params[:id])

      @project_data[:related_docs] = result.try(:rows)

    end

    # This user comes from IATI Data Explorer. The IATI Data Explorer is an externalvisualization tool for government information in Aid Projects.
    # The visualization tool provides a link to Open Aid Register so that NGO users can introduce additional information when they see their funding program
    if params[:related_activity]
      @project_data[:program_guid] = params[:related_activity]
    end
    render :template => '/project/show'
    return

  end

end
