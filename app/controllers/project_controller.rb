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
             #no errors, save the data and redirect to dashboard
        redirect_to '/dashboard'
        else
        #there has been errors print them on the template
        end   
    end
    
  


  end
  
    def view
      
    
      sql="select * FROM projects WHERE title = 'Titulo1'"
      result = CartoDB::Connection.query(sql) 
    @view_project = result.rows.first
    
     render :template => '/project/new'
    end
  
  
end
