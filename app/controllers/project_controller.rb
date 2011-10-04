class ProjectController < ApplicationController
  
  
  def show
    
    unless session[:organization]
      session[:return_to] = request.request_uri
       redirect_to '/login'
       return
    end
    #We need to initialize the hash
    @errors = Array.new  
    @project_data = {}
    
    
    if params[:method]=="post"
      @project_data = params      
      if params[:title].blank?
        @errors.push("You need to enter a project title")
      end
      if !params[:budget].blank?
        if !is_a_number?(params[:budget])
          @errors.push("Budget must be written in numbers")
        end
        if params[:budget_currency].eql?("1")
          @errors.push("You need to select a currency")
        end
      end
      #Provide a Project_guid if it doesnt have any and check if there is already a project with that guid
      if params[:project_guid].blank?
        now = DateTime.now.to_s(:number)
        params[:project_guid] = now
      end
      sql = "SELECT * FROM projects WHERE organization_id = '#{session[:organization].cartodb_id}'"
      result =  CartoDB::Connection.query(sql) 
      result.rows.each do |project|
        #check if there is no repeted cartodb_id but only when it is updating project
        if params[:project_guid] == project.project_guid && params[:cartodb_id] != project.cartodb_id.to_s
          @errors.push("Please change the project id. You have already one project with this id")
        end
      end
      #Prepare the date to be inserted in CartoDB and check also if it is not right      
      if (params[:start_date_day].blank?) && (params[:start_date_month].blank?) && (params[:start_date_year].blank?)
        start_date = "null"
      elsif (params[:start_date_day].blank?) || (params[:start_date_month].blank?) || (params[:start_date_year].blank?)
        @errors.push("You need to enter all parameters (day, month and year) in the start date") 
      else 
        s_date = Date.civil(params[:start_date_year].to_i,params[:start_date_month].to_i,params[:start_date_day].to_i)
        start_date = "'" + s_date.to_s() + "'"
      end
      if (params[:end_date_day].blank?) && (params[:end_date_month].blank?) && (params[:end_date_year].blank?)
        end_date = "null"
      elsif (params[:end_date_day].blank?) || (params[:end_date_month].blank?) || (params[:end_date_year].blank?)
        @errors.push("You need to enter all parameters (day, month and year) in the start date") 
      else
        e_date = Date.civil(params[:end_date_year].to_i,params[:end_date_month].to_i,params[:end_date_day].to_i)
        end_date = "'" + e_date.to_s() + "'"
      end
      if (s_date<=>(e_date)) == 1
        @errors.push("The end date must be later than the start date") 
      end
      
      # prepare the geom
      
      if params[:google_markers].blank?
       params[:google_markers] = 'MULTIPOINT EMPTY'
      end
      #there has been errors print them on the template AND EXIT
      if @errors.count>0
        render :template => '/project/show'
        return
      end
      #no errors,introduce the data in CartoDB
      if params[:cartodb_id].blank?
        #It is a new project, save to cartodb
        #other_org_name and other_org_role should be included next time
        sql="INSERT INTO PROJECTS (organization_id, title, description, the_geom, language, project_guid, start_date, 
          end_date, budget, budget_currency, website, program_guid, result_title, 
                 result_description, collaboration_type, tied_status, aid_type, flow_type, finance_type, contact_name, contact_email, contact_position) VALUES 
                 (#{session[:organization].cartodb_id}, '#{params[:title]}', '#{params[:description]}', 
                ST_GeomFromText('#{params[:google_markers]}',4326),
                 '#{params[:language]}', 
                 '#{params[:project_guid]}', #{start_date}, #{end_date}, '#{params[:budget]}',
                 '#{params[:budget_currency]}', '#{params[:website]}', '#{params[:program_guid]}', '#{params[:result_title]}', 
                 '#{params[:result_description]}',  
                 '#{params[:collaboration_type]}','#{params[:tied_status]}',
                 '#{params[:aid_type]}',
                 '#{params[:flow_type]}','#{params[:finance_type]}',
                 '#{params[:contact_name]}',
                 '#{params[:contact_email]}', '#{params[:contact_position]}')"
         CartoDB::Connection.query(sql)
         
         # Now sectors must be written
         if params[:sector_id]
           sql = "SELECT * from PROJECTS WHERE organization_id=#{session[:organization].cartodb_id} ORDER BY cartodb_id DESC LIMIT 1 "      
           result = CartoDB::Connection.query(sql)
           params[:sector_id].each do |sectors|
             sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (#{result.rows.first[:cartodb_id]}, #{sectors})"
             CartoDB::Connection.query(sql)
           end
          end
          
           # Now all partner organizations must be written
          if !params[:other_org_name_1].blank?
            #Get the new cartodb_id
            sql = "SELECT * from PROJECTS WHERE organization_id=#{session[:organization].cartodb_id} ORDER BY cartodb_id DESC LIMIT 1 "      
            result = CartoDB::Connection.query(sql)     
            for i in 1..5
              aux_name = eval("params[:other_org_name_" + i.to_s() + "]")
              aux_role = eval("params[:other_org_role_" + i.to_s() + "]")
              if !aux_name.blank?  
                #insert organization
                sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (#{result.rows.first[:cartodb_id]}, '#{aux_name}', '#{aux_role}')"
                CartoDB::Connection.query(sql)
              else
                break
              end
            end  
          end
        
      else
        #it is an existing project do whatever
        
        sql="UPDATE projects SET the_geom=ST_GeomFromText('#{params[:google_markers]}',4326), description ='#{params[:description]}', language= '#{params[:language]}', project_guid='#{params[:project_guid]}', start_date=#{start_date}, end_date=#{end_date}, budget='#{params[:budget]}', budget_currency='#{params[:budget_currency]}', 
         website='#{params[:website]}', program_guid = '#{params[:program_guid]}', result_title='#{params[:result_title]}', 
         result_description='#{params[:result_description]}', collaboration_type='#{params[:collaboration_type]}',tied_status ='#{params[:tied_status]}',
         aid_type ='#{params[:aid_type]}', flow_type ='#{params[:flow_type]}',finance_type ='#{params[:finance_type]}',contact_name='#{params[:contact_name]}', contact_email='#{params[:contact_email]}', contact_position ='#{params[:contact_position]}' WHERE cartodb_id='#{params[:cartodb_id]}'"
         CartoDB::Connection.query(sql)
         #In this case, first delete all sectors and overwrite them
         sql = "DELETE FROM project_sectors where  project_id = '#{params[:cartodb_id]}'"
         CartoDB::Connection.query(sql)
         if params[:sector_id]
           params[:sector_id].each do |sectors|
             sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (#{params[:cartodb_id]}, '#{sectors}')"
             CartoDB::Connection.query(sql)
           end
         end
         #In this case, first delete all partner organizations and overwrite them
         sql = "DELETE FROM project_partnerorganizations where  project_id = '#{params[:cartodb_id]}'"
         if !params[:other_org_name_1].blank?
           for i in 1..5
             aux_name = eval("params[:other_org_name_" + i.to_s() + "]")
             aux_role = eval("params[:other_org_role_" + i.to_s() + "]")
             if !aux_name.blank?  
               #insert organization
               sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (#{params[:cartodb_id]}, '#{aux_name}', '#{aux_role}')"
               CartoDB::Connection.query(sql)
             else
               break
             end
           end
         end
      end
      redirect_to '/dashboard'
      return  
    end
     
     
    #it is a GET method
    if params[:id] #if it is an existing project select everything from projects and from project_sectors
      
      sql="select cartodb_id, organization_id, title, description, language, project_guid, start_date, 
        end_date, budget, budget_currency, website, program_guid, result_title, 
               result_description, collaboration_type, tied_status, aid_type, flow_type, 
               finance_type, contact_name, contact_email, contact_position, ST_ASText(the_geom) AS google_markers
               FROM projects WHERE cartodb_id = #{params[:id]}"
               
      result = CartoDB::Connection.query(sql) 
      @project_data = result.rows.first
      
      #@project_data[:google_markers] = @project_data[:st_astext]
      
      #transform the start_date and end_date in month, day, year
      if @project_data[:start_date]
      @project_data.start_date_day = @project_data[:start_date].day
      @project_data.start_date_month = @project_data[:start_date].month
      @project_data.start_date_year = @project_data[:start_date].year
      end
      if @project_data[:end_date]
      @project_data.end_date_day = @project_data[:end_date].day
      @project_data.end_date_month = @project_data[:end_date].month
      @project_data.end_date_year = @project_data[:end_date].year
      end
      #select sectors and form the array
      sql = "select array_agg(sector_id) from project_sectors where project_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql)
     
      @project_data[:sector_id] = eval('['+result.rows.first[:array_agg][1..-2]+']')
      
      #Select partner organizations and form the array
      sql = "select array_agg(other_org_name) as array_other_orgs, 
      array_agg(other_org_role) as array_other_roles 
      from project_partnerorganizations where project_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql)
      
      #misssing the conversion
    
        @project_data[:other_org_name_1] = result.rows.first[:array_other_orgs][0]
         @project_data[:other_org_role_1] = result.rows.first[:array_other_roles][0]
         @project_data[:other_org_name_2] = result.rows.first[:array_other_orgs][1]
         @project_data[:other_org_role_2] = result.rows.first[:array_other_roles][1]
         @project_data[:other_org_name_3] = result.rows.first[:array_other_orgs][2]
         @project_data[:other_org_role_3] = result.rows.first[:array_other_roles][2]
         @project_data[:other_org_name_4] = result.rows.first[:array_other_orgs][3]
         @project_data[:other_org_role_4] = result.rows.first[:array_other_roles][3]
         @project_data[:other_org_name_5] = result.rows.first[:array_other_orgs][4]
         @project_data[:other_org_role_5] = result.rows.first[:array_other_roles][4]
    end
    
    # This user comes from IATI Data Explorer
    if params[:related_activity]
      @project_data[:program_guid] = params[:related_activity] 
    end
    render :template => '/project/show'
    return
    
  end
  
  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
  
end
