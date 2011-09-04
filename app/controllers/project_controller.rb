class ProjectController < ApplicationController
  
  
  def show
    
    if session[:organization]
    else
       redirect_to '/login'
       return
    end
    
    
    #valida los datos que vengan si es que es un post
    @errors = Array.new  
    
    #We need to initialize the hash
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
       if params[:budget_currency].match("1")
         @errors.push("You need to select a currency")
        end
    end
        
      #Solve the project_guid problem
      
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
      
      
      # check that the end date cant be before the start date
            
      #Solve the date problem when it is blank and also sent as a string when it isnt blank for the DB
      
      # finish this issue
      
       if (params[:start_date][:"written_on(1i)"].blank?) && (params[:start_date][:"written_on(2i)"].blank?) && (params[:start_date][:"written_on(3i)"].blank?)
        start_date = "null"
        elsif (params[:start_date][:"written_on(1i)"].blank?) || (params[:start_date][:"written_on(2i)"].blank?) || (params[:start_date][:"written_on(3i)"].blank?)
         @errors.push("You need to enter all parameters (day, month and year) in the start date") 
        else
        start_date = Date.civil(params[:start_date][:"written_on(1i)"].to_i,params[:start_date][:"written_on(2i)"].to_i,params[:start_date][:"written_on(3i)"].to_i)
        end

        if (params[:end_date][:"written_on(1i)"].blank?) && (params[:end_date][:"written_on(2i)"].blank?) && (params[:end_date][:"written_on(3i)"].blank?)
        end_date = "null"
        elsif (params[:end_date][:"written_on(1i)"].blank?) || (params[:end_date][:"written_on(2i)"].blank?) || (params[:end_date][:"written_on(3i)"].blank?)
          @errors.push("You need to enter all parameters (day, month and year) in the end date") 
        else
          end_date = Date.civil(params[:end_date][:"written_on(1i)"].to_i,params[:end_date][:"written_on(2i)"].to_i,params[:end_date][:"written_on(3i)"].to_i)
        end
        
        
      
       if (start_date<=>(end_date)) == 1
         @errors.push("The end date must be later than the start date") 
      end
      
      
      if @errors.count>0
        #there has been errors print them on the template AND EXIT
        
        render :template => '/project/show'
        
        return
        
      end
      
       
     
      
     # finish the date issue
      
      
      if params[:cartodb_id].blank?
        #It is a new project, save to cartodb
        #other_org_name and other_org_role should be included next time
        
      
        
        
        sql="INSERT INTO PROJECTS (organization_id, title, description, language, sector_id, project_guid, start_date, 
          end_date, budget, budget_currency, website, program_guid, result_title, 
                 result_description, contact_name, contact_email, contact_position) VALUES 
                 (#{session[:organization].cartodb_id}, '#{params[:title]}', '#{params[:description]}', '#{params[:language]}', '#{params[:sector_id]}',
                 '#{params[:project_guid]}', #{start_date}, #{end_date}, '#{params[:budget]}',
                 '#{params[:budget_currency]}', '#{params[:website]}', '#{params[:program_guid]}', '#{params[:result_title]}', '#{params[:result_description]}', '#{params[:contact_name]}',
                 '#{params[:contact_email]}', '#{params[:contact_position]}')"
         CartoDB::Connection.query(sql)
      else
        
        
        #it is an existing project do whatever
        sql="UPDATE projects SET description ='#{params[:description]}', language= '#{params[:language]}', sector_id='#{params[:sector_id]}', project_guid='#{params[:project_guid]}', start_date='#{start_date}', end_date='#{end_date}', budget='#{params[:budget]}', budget_currency='#{params[:budget_currency]}', 
         website='#{params[:website]}', program_guid = '#{params[:program_guid]}', result_title='#{params[:result_title]}', 
         result_description='#{params[:result_description]}', contact_name='#{params[:contact_name]}', contact_email='#{params[:contact_email]}', contact_position ='#{params[:contact_position]}' WHERE cartodb_id='#{params[:cartodb_id]}'"
       CartoDB::Connection.query(sql)
      
      end
      redirect_to '/dashboard'
      return
      
    end
    
    
    if params[:id]
      sql="select * FROM projects WHERE cartodb_id = #{params[:id]}"
      result = CartoDB::Connection.query(sql) 
      @project_data = result.rows.first

      
    end
    
    render :template => '/project/show'
    return
      
    
  end
  
  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
  end
  
    
  
  
end
