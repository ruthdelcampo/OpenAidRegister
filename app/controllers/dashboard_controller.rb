class DashboardController < ApplicationController
  
  def show 
    if session[:organization].blank?
      redirect_to '/login'
      return
    end
    #Show the selection of projects
    sql="SELECT * FROM projects WHERE organization_id = #{session[:organization].cartodb_id}"
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
   @fake_sector_distribution = [12, 0, 0, 0, 0, 0, 84, 4] 
  end
  
  def import_file
  end
  
  def download
    if session[:organization].blank?
      redirect_to '/login'
    else
      sql="SELECT * FROM projects WHERE organization_id = #{session[:organization].cartodb_id}"
      result = CartoDB::Connection.query(sql)
      @download_projects = result.rows
      sql = "select project_id, array_agg(project_sectors.sector_id) AS sector_id from project_sectors INNER JOIN projects ON project_sectors.project_id = projects.cartodb_id WHERE organization_id =#{session[:organization].cartodb_id} GROUP BY project_id"
      result = CartoDB::Connection.query(sql)
      @download_sectors = result.rows
      sql = "select project_sectors.sector_id, name from project_sectors INNER JOIN sectors ON project_sectors.sector_id = sectors.sector_id"
      result = CartoDB::Connection.query(sql)
      @download_sector_names = result.rows 
      render :template => '/dashboard/download.xml.erb'
    end
   end
   
   def delete
     sql="delete FROM projects where projects.cartodb_id = '#{params[:delete_project_id]}'"
     CartoDB::Connection.query(sql)
     sql="delete FROM project_sectors where project_id = '#{params[:delete_project_id]}'"
     CartoDB::Connection.query(sql)
     redirect_to  '/dashboard'
   end

end
