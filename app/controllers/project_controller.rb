class ProjectController < ApplicationController
  
  
  def show #Working partially except other organizations and review date parameters
    
if params[:method]=="post"
  
end

     if session[:organization].blank?
      session[:return_to] = request.request_uri
       redirect_to '/login'
       return
    end
    
    #We need to initialize the hash
    @errors = Array.new  
    @project_data = {}
    
    if params[:method]=="post"#the form comes with the params
      
      @project_data = params  #this works when it is a new project or a existing one    
      
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
      
      
      if params[:project_guid].blank?
       @errors.push("You need to enter a project id")
      end
      
      #check that the project id is unique for this user
      sql = "SELECT cartodb_id, project_guid FROM projects WHERE organization_id = '#{session[:organization].cartodb_id}'"
      result =  CartoDB::Connection.query(sql) 
      result.rows.each do |project|
        #check if there is no repeted cartodb_id but only when it is updating project
        if params[:project_guid] == project.project_guid && params[:cartodb_id] != project.cartodb_id.to_s
          @errors.push("Please change the project id. You have already one project with this id")
        end
      end
      
      #Check if the day is not correct
      
      #   for instance when there is an end date but not a start date
      if !(params[:end_date] =="") && (params[:start_date]=="")
         @errors.push("You need to have a start date when you have introduced and end date")
      end
      # End date can be earlier as the start date
      if !(params[:end_date] =="") && !(params[:start_date]=="")
           ((Date.parse(params[:start_date]))<=>(Date.parse(params[:end_date]))) == 1 ##I need to check if this still works with the new way of date
            @errors.push("The end date must be later than the start date")
      end 
      #Prepare the date to be inserted in CartoDB
      if (params[:start_date]=="")
        params[:start_date] = "null"
      end
      if (params[:end_date] =="")
        params[:end_date] = "null"
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
        sql="INSERT INTO PROJECTS (organization_id, title, description, the_geom, language, project_guid, start_date, 
          end_date, budget, budget_currency, website, program_guid, result_title, 
                 result_description, collaboration_type, tied_status, aid_type, flow_type, finance_type, contact_name, contact_email, contact_position) VALUES 
                 (#{session[:organization].cartodb_id}, '#{params[:title]}', '#{params[:description]}', 
                ST_GeomFromText('#{params[:google_markers]}',4326),
                 '#{params[:language]}', 
                 '#{params[:project_guid]}', #{params[:start_date]}, #{params[:end_date]}, '#{params[:budget]}',
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
           sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=#{session[:organization].cartodb_id} ORDER BY cartodb_id DESC LIMIT 1 "      
           result = CartoDB::Connection.query(sql)
           params[:sector_id].each do |sectors|
             sql = "INSERT INTO project_sectors (project_id, sector_id) VALUES (#{result.rows.first[:cartodb_id]}, #{sectors})"
             CartoDB::Connection.query(sql)
           end
          end
          
           # This is not working and should be updated when dynamic organizations are well done
          if !params[:other_org_name_1].blank?
            #Get the new cartodb_id because the project is new
            sql = "SELECT cartodb_id from PROJECTS WHERE organization_id=#{session[:organization].cartodb_id} ORDER BY cartodb_id DESC LIMIT 1 "      
            result = CartoDB::Connection.query(sql)     
            
            for i in 1..5
              aux_name = eval("params[:other_org_name_" + i.to_s() + "]")
              aux_role = eval("params[:other_org_role_" + i.to_s() + "]")
              if !aux_name.blank?  
                #insert organization
                #sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (#{result.rows.first[:cartodb_id]}, '#{aux_name}', '#{aux_role}')"
                #CartoDB::Connection.query(sql)
              else
                break
              end
            end  
          end
        
      else
        #it is an existing project do whatever
        sql="UPDATE projects SET the_geom=ST_GeomFromText('#{params[:google_markers]}',4326), description ='#{params[:description]}', language= '#{params[:language]}', project_guid='#{params[:project_guid]}', start_date=#{params[:start_date]}, end_date=#{params[:end_date]}, budget='#{params[:budget]}', budget_currency='#{params[:budget_currency]}', 
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
         
         #In this case, first delete all partner organizations and overwrite them. This needs to be rewritten when it is correctly working
         sql = "DELETE FROM project_partnerorganizations where  project_id = '#{params[:cartodb_id]}'"
         if !params[:other_org_name_1].blank?
           for i in 1..5
             aux_name = eval("params[:other_org_name_" + i.to_s() + "]")
             aux_role = eval("params[:other_org_role_" + i.to_s() + "]")
             if !aux_name.blank?  
               #insert organization
               #sql = "INSERT INTO project_partnerorganizations (project_id, other_org_name, other_org_role) VALUES (#{params[:cartodb_id]}, '#{aux_name}', '#{aux_role}')"
               #CartoDB::Connection.query(sql)
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
    if params[:id] # it is an existing project select everything from projects and from project_sectors
      
      sql="select cartodb_id, organization_id, title, description, language, project_guid, start_date, 
        end_date, budget, budget_currency, website, program_guid, result_title, 
               result_description, collaboration_type, tied_status, aid_type, flow_type, 
               finance_type, contact_name, contact_email, contact_position, ST_ASText(the_geom) AS google_markers
               FROM projects WHERE cartodb_id = #{params[:id]}"
               
      result = CartoDB::Connection.query(sql) 
      @project_data = result.rows.first
      
      #@project_data[:google_markers] = @project_data[:st_astext]
      
      #select sectors and form the array
      sql = "select array_agg(sector_id) from project_sectors where project_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql)
     
     if !result.rows.first[:array_agg].blank?
      @project_data[:sector_id] = eval('['+result.rows.first[:array_agg][1..-2]+']')
    end
      #This must be fixed when other organizations is done
      #Select partner organizations and form the array
      sql = "select array_agg(other_org_name) as array_other_orgs, 
      array_agg(other_org_role) as array_other_roles 
      from project_partnerorganizations where project_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql)
      
    end
    
    # This user comes from IATI Data Explorer. The IATI Data Explorer is an externalvisualization tool for government information in Aid Projects. 
    # The visualization tool provides a link to Open Aid Register so that NGO users can introduce additional information when they see their funding program
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
