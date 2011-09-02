class ProjectController < ApplicationController
  
  def new
    
      if session[:organization]
      else
         redirect_to '/login'
      end
      

    if params[:method]=="post"
      @errors = Array.new
        # Title validation
        if params[:title].blank?
         @errors.push("You need to enter a project title")
        end
        if !params[:budget].blank? && params[:budget_currency].match("1")
         @errors.push("You need to select a currency")
        end
      
        if @errors.count==0
          
          #save to CartoDB
          #####Necesito cambiar organization_guid por el valor de session[:organization].cartodb_id
          #other_org_name and other_org_role should be included next time
          
        
          sql="INSERT INTO PROJECTS (organization_guid, title, description, language, sector_id, project_guid, start_date, 
          end_date, budget, budget_currency, website, program_guid, result_title, 
          result_description, contact_name, contact_email, contact_position) VALUES 
          (1, '#{params[:title]}', '#{params[:description]}', '#{params[:language]}', '#{params[:sector_id]}',
          '#{params[:project_guid]}', '#{params[:start_date]}', '#{params[:end_date]}', '#{params[:budget]}',
          '#{params[:budget_currency]}', '#{params[:website]}', '#{params[:program_guid]}', '#{params[:result_title]}', '#{params[:result_description]}', '#{params[:contact_name]}',
          '#{params[:contact_email]}', '#{params[:contact_position]}')"
          CartoDB::Connection.query(sql)
             #no errors, save the data and redirect to dashboard
        redirect_to '/dashboard'
        else
        #there has been errors print them on the template
        end   
    end
    
  


  end
  
    def view
      
        if params[:method]=="post"
           @errors = Array.new
             # Title validation
             if params[:title].blank?
              @errors.push("You need to enter a project title")
             end
             if !params[:budget].blank? && params[:budget_currency].match("1")
              @errors.push("You need to select a currency")
             end

             if @errors.count==0

               #save new values to CartoDB UPDATE table_name SET column1=value, column2=value2,... WHERE some_column=some_value

               sql="UPDATE projects SET description ='#{params[:description]}', language= '#{params[:language]}', sector_id='#{params[:sector_id]}', project_guid='#{params[:project_guid]}', start_date='#{params[:start_date]}', end_date='#{params[:end_date]}', budget='#{params[:budget]}', budget_currency='#{params[:budget_currency]}', 
               website='#{params[:website]}', program_guid = '#{params[:program_guid]}', result_title='#{params[:result_title]}', 
               result_description='#{params[:result_description]}', contact_name='#{params[:contact_name]}', contact_email'#{params[:contact_email]}', contact_position ='#{params[:contact_position]}') WHERE cartodb_id='#{params[:submit_id]}'"

               CartoDB::Connection.query(sql)
                  #no errors, save the data and redirect to dashboard
             redirect_to '/dashboard'
             else
             #there has been errors print them on the template
             end
           else
    
           #There should be a way for passing an id from the link_to button
             sql="select * FROM projects WHERE title = 'Titulo1'"
             result = CartoDB::Connection.query(sql) 
           @view_project = result.rows.first
            render :template => '/project/view'
         
          end
    end
  
  
end
