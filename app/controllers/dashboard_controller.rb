class DashboardController < ApplicationController
  
  def show 
    
    if session[:organization].blank?
      session[:return_to] = request.request_uri
      redirect_to '/login'
      return
    end
    @errors = Array.new  # We need to initialize the errors array to be shown when there is aproblem with import file
    #Show the selection of projects
    sql="SELECT * FROM projects WHERE organization_id = #{session[:organization][:cartodb_id]}"
    result = CartoDB::Connection.query(sql)
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
    #look for the sector distribution of this organization
    #sql = "select sector_id, COUNT(sector_id) from project_sectors INNER JOIN projects ON project_sectors.project_id = projects.cartodb_id WHERE organization_id =#{params[:id]} GROUP BY sector_id"
    sql = "select sectors.name, COUNT(project_sectors.sector_id) AS countnumofprojectsinthissector 
    from sectors INNER JOIN (project_sectors INNER JOIN projects ON project_sectors.project_id = projects.cartodb_id) 
    ON sectors.cartodb_id = project_sectors.sector_id WHERE organization_id =#{session[:organization][:cartodb_id]} 
    GROUP BY project_sectors.sector_id, sectors.name"
    
    result = CartoDB::Connection.query(sql)      
    @sector_distribution = result.rows
    
  end
  
  def import_file
    unless session[:organization]
      redirect_to '/login'
      return
    end
    
    if !params[:file_upload]
      redirect_to '/dashboard', :alert => "You need to choose a file first to be able to upload it"
      return
    end  
    
    require 'fileutils'
    tmp = params[:file_upload][:my_file].tempfile
    file = File.join("uploads", params[:file_upload][:my_file].original_filename + "_" + session[:organization][:cartodb_id].to_s())
    FileUtils.cp tmp.path, file
    redirect_to '/dashboard', :notice => "Thanks for uploading the file. We are going to import your projects. In a few days you will see you projects uploaded. We will send you an email when the process is completed"
    return 
  end
  
  def download
    sql="SELECT * FROM organizations WHERE cartodb_id = #{params[:id]}"
    result = CartoDB::Connection.query(sql)
    @download_organization = result.rows.first
    #we need to check if there is an existing organization, else it will be error 404
    if (!@download_organization.blank?)
      sql="SELECT  cartodb_id, organization_id, title, description, language, project_guid, start_date, 
      end_date, budget, budget_currency, website, program_guid, result_title, 
      result_description, collaboration_type, tied_status, aid_type, flow_type, 
      finance_type, contact_name, contact_email, contact_position, 
      ST_ASText(the_geom) AS google_markers, updated_at
      FROM projects WHERE organization_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql)
      @download_projects = result.rows
      #Render XML if it has already projects entered and the organization is validated
      if (@download_organization[:is_validated]) && (!@download_projects.blank?) 
        sql = "select project_id, array_agg(project_sectors.sector_id) AS sector_id from project_sectors 
        INNER JOIN projects ON project_sectors.project_id = projects.cartodb_id 
        WHERE organization_id =#{params[:id]} GROUP BY project_id"
        result = CartoDB::Connection.query(sql)
        result.rows.each do |row|
          row[:sector_id] = eval('['+row[:sector_id][1..-2]+']')
        end
        
        
        @download_sectors = result.rows
        
        
        sql = "select project_sectors.sector_id, name, sector_code from project_sectors INNER JOIN sectors ON project_sectors.sector_id = sectors.cartodb_id"
        result = CartoDB::Connection.query(sql)
        @download_sector_names = result.rows
        #now partner organizations
        sql = "select project_id, array_agg(project_partnerorganizations.other_org_name) AS other_org_names, array_agg(project_partnerorganizations.other_org_role) AS other_org_roles  
        from project_partnerorganizations INNER JOIN projects ON project_partnerorganizations.project_id = projects.cartodb_id 
        WHERE organization_id = #{params[:id]} GROUP BY project_id"
        result = CartoDB::Connection.query(sql)
        debugger
        result.rows.each do |row|
          row[:other_org_names] = eval('['+row[:other_org_names][1..-2]+']')
          row[:other_org_roles] = eval('['+row[:other_org_roles][1..-2]+']')  
        end
        @download_other_orgs = result.rows
        
        render :template => '/dashboard/download.xml.erb'
      else
        render :template => '/dashboard/download_empty.html.erb'
      end
    else
      redirect_to '/public/404.html'
    end
  end
   
  def delete
    if session[:organization].blank?
      redirect_to '/login'
      return
    end
     sql="delete FROM projects where projects.cartodb_id = '#{params[:delete_project_id]}'"
     CartoDB::Connection.query(sql)
     sql="delete FROM project_sectors where project_id = '#{params[:delete_project_id]}'"
     CartoDB::Connection.query(sql)
     redirect_to  '/dashboard'
   end

end
