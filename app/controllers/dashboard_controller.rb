class DashboardController < ApplicationController
  
  def show
       
        if session[:organization].blank?
           redirect_to '/login'
           return
        end
        
          
      sql="SELECT * FROM projects WHERE organization_id = #{session[:organization].cartodb_id}"
      result = CartoDB::Connection.query(sql)
       @projects_list = result.rows
      
       @current_projects = 0
       @past_projects = 0
       
       @projects_list.each do |project|
         
         if (project[:end_date]== nil) || ((project[:end_date]<=> Date.current) ==1)
             @current_projects +=1
           else
             @past_projects +=1
           end
      end
      
      
      
       @fake_sector_distribution = [12, 0, 0, 0, 0, 0, 84, 4] 
  end
  
  def import_file
 
  end
  
   def download
     sql="SELECT * FROM projects WHERE organization_id = #{session[:organization].cartodb_id}"
      result = CartoDB::Connection.query(sql)
      
      # download_projects is an array which may contain 0 or more projects
      @download_projects = result.rows
     
     # sql = "SELECT * FROM project_sectors WHERE project_id = aqui es complicado...mirar como deberia ser hecho en realidad"
      
      
     render :template => '/dashboard/download.xml.erb'
   end
   
   def delete
 
    project_id = params[:delete_project_id]
    
      sql="delete FROM projects where projects.cartodb_id = '#{params[:delete_project_id]}'"
      result = CartoDB::Connection.query(sql)
      redirect_to  '/dashboard'
 end
end
