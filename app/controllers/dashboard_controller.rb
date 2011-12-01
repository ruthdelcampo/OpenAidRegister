class DashboardController < ApplicationController

  def show

    if session[:organization].blank?
      session[:return_to] = request.request_uri
      redirect_to '/login'
      return
    end
    @errors = Array.new  # We need to initialize the errors array to be shown when there is aproblem with import file

    # Selects markers in all projects
    sql = <<-SQL
      SELECT p.cartodb_id,
             ST_ASText(p.the_geom) AS project_markers,
             p.title,
             array_agg(ps.sector_id) AS sectors,
             (p.budget || p.budget_currency) AS budget,
             p.start_date,
             p.end_date
      FROM projects p
      LEFT OUTER JOIN project_sectors ps ON ps.project_id = p.cartodb_id
      WHERE p.organization_id = ?
      GROUP BY p.cartodb_id,
               project_markers,
               p.title,
               p.budget,
               p.budget_currency,
               p.start_date,
               p.end_date
    SQL
    result = execute_query(sql, session[:organization][:cartodb_id])
    @projects_list = result.rows
    @current_projects = 0
    @past_projects = 0

    #check which ones are current and which are past
    @projects_list.each do |project|
      if (project[:end_date]== nil) || ((project[:end_date]<=> Date.current) ==1)
        @current_projects +=1
      else
        @past_projects +=1
      end
    end
  end


  def import_file #not completely working. Need to add functionallity

    redirect_to '/login' and return if session[:organization].blank?

    redirect_to '/dashboard', :alert => "You need to choose a file first" and return if params[:file_upload].blank?

    file_name = params[:file_upload].original_filename
    file      = params[:file_upload].tempfile
    
     result = AWS::S3::S3Object.store("#{session[:organization][:cartodb_id]}_#{file_name}", file, 'openaidregister_uploads')
      
    
    #send an email notification to ruth del Campo
    UserMailer.new_file(session[:organization], file_name).deliver
    
    redirect_to '/dashboard', :notice => <<-EOF
      Thanks for uploading the file.
      We are going to import your projects.
      In a few days you will see you projects uploaded. 
      We will contact you if we need some help and you will get an email when the process is completed.
    EOF
    return
  end

  def download

    #take the organization information. This request can also be done from outside people
    sql="SELECT is_validated, organization_country, organization_guid,
    organization_name, organization_type_id
    FROM organizations WHERE cartodb_id = ?"
    result = execute_query(sql, params[:id])
    @download_organization = result.rows.first

    #we need to check if there is an existing organization, else it will be error 404
    if (!@download_organization.blank?)

      #get the project info
      sql="SELECT  cartodb_id, organization_id, title, description, language, project_guid, start_date,
      end_date, budget, budget_currency, website, program_guid, result_title,
      result_description, collaboration_type, tied_status, aid_type, flow_type,
      finance_type, contact_name, contact_email,
      ST_ASText(the_geom) AS google_markers, created_at, updated_at
      FROM projects WHERE organization_id = ?"
      result = execute_query(sql, params[:id])
      @download_projects = result.rows

      #Render XML if it has already projects entered and the organization is validated

       if !@download_projects.blank?

        # get the se project_sector info
        sql = "select project_id, array_agg(project_sectors.sector_id) AS sector_id from project_sectors
        INNER JOIN projects ON project_sectors.project_id = projects.cartodb_id
        WHERE organization_id =? GROUP BY project_id"
        result = execute_query(sql, params[:id])

        result.rows.each do |row|
          row[:sector_id] = eval('['+row[:sector_id][1..-2]+']')

        end
        @download_sectors = result.rows


        #get the sector names
        sql = "select project_sectors.sector_id, name, sector_code from project_sectors
        INNER JOIN sectors ON project_sectors.sector_id = sectors.cartodb_id"
        result = execute_query(sql)
        @download_sector_names = result.rows


        #now partner organizations. I need to check if this finally works well
        sql = "select project_id, array_agg(project_partnerorganizations.other_org_name) AS other_org_names,
        array_agg(project_partnerorganizations.other_org_role) AS other_org_roles
        from project_partnerorganizations INNER JOIN projects ON project_partnerorganizations.project_id = projects.cartodb_id
        WHERE organization_id = ? GROUP BY project_id"
        result = execute_query(sql, params[:id])
        result.rows.each do |row|
          row[:other_org_names] = row[:other_org_names][1..-2].split(",")
          row[:other_org_roles] = row[:other_org_roles][1..-2].split(",")

        end
        @download_other_orgs = result.rows
        
        
        #now transactions 
        sql = "select project_id, transaction_type, transaction_value, transaction_currency, 
        transaction_date, provider_activity_id, provider_name, provider_id, receiver_activity_id,
        receiver_name, receiver_id, transaction_description
        from project_transactions INNER JOIN projects ON project_transactions.project_id = projects.cartodb_id
        WHERE organization_id = ?"
        result = execute_query(sql, params[:id])
        @transaction_list = result.rows
        
          #now partner organizations. I need to check if this finally works well
          sql = "select project_id, doc_url, doc_type
          from project_relateddocs INNER JOIN projects ON project_relateddocs.project_id = projects.cartodb_id
          WHERE organization_id = ?"
          result = execute_query(sql, params[:id])
          @download_related_docs = result.rows
          
          debugger
        
        #get the geo information
        sql = "select project_id, level_detail, array_agg(reverse_geo.country) AS country,
        array_agg(reverse_geo.adm1) AS adm1, array_agg(reverse_geo.adm2) AS adm2 from reverse_geo
        INNER JOIN projects ON reverse_geo.project_id = projects.cartodb_id
        WHERE organization_id = ? GROUP BY project_id, level_detail"
        result = execute_query(sql, params[:id])
         result.rows.each do |row|
            #dont know why country behaves different than the other elements
            row[:adm1] = row[:adm1][1..-2].split(",")
            row[:adm2] = row[:adm2][1..-2].split(",")
          end
        @download_geo_projects = result.rows


        #finally render the XML
        render :template => '/dashboard/download.xml.erb',  :layout => false

      else #if there are still no projects
        render :template => '/dashboard/download_empty.html.erb',  :layout => false
      end

    else #if the organization doesnt exist
      render :status => 404
    end
  end


  def delete #deletes records in the three tables
    if session[:organization].blank?
      redirect_to '/login'
      return
    end

    sql="delete FROM projects where projects.cartodb_id = '?'"
    execute_query(sql, params[:delete_project_id])

    sql="delete FROM project_sectors where project_id = '?'"
    execute_query(sql, params[:delete_project_id])

    sql="delete FROM project_partnerorganizations where project_id = '?'"
    execute_query(sql, params[:delete_project_id])
    
    sql="delete FROM project_relateddocs where project_id = '?'"
    execute_query(sql, params[:delete_project_id])

    sql="delete FROM reverse_geo where project_id = '?'"
    execute_query(sql, params[:delete_project_id])

    redirect_to  '/dashboard'
   end


   def publish #not working
      if session[:organization].blank?
        redirect_to '/login'
        return
      end
       redirect_to "/dashboard", :notice=>"Sorry, this functionality is not yet implemented but you can always contact us for help"

      #if session[:organization][:is_valid_publish]
      #   #send to IATI REgistry
      #     if # no_success
      #        #email to contact@openaidregister to check what happened
      #        render :text => 'There was an error while inserting the data in IATI Registry. Please try again later or contact us'
      #      else #if success
      #        #sql insert new data since it was succesful
      #          api_key = params[:api_key]
      #          name_package = params[:name_package]
      #        render :text => "Succesfully updated"
      #       end
      #elsif session[:organization][:api_key].present? && session[:organization][:package_name].present?
      #    if #no success
      #      #email to contact@openaidregister to check what happened
      #      render :text => 'There was an error while inserting the data in IATI Registry. Please check your IATI Details are correct'
      #    else #if success
      #      session[:organization][:is_valid_publish]
      #    end
      #else
      #    redirect_to '/dashboard', :alert => "Please, introduce your IATI Registry (api key and the name package) details in your account. We need this information to be able to publish your data in the Registry.  For more information or if you dont know how to do this step, please send us an email to contact@openaidregister.org"
      #end

  end

end
