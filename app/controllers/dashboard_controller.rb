class DashboardController < ApplicationController
  def show
       
       
       @fake_project_1 ={:name => 'first project from this organization', :ID =>'orgID1', :url => 'www.foo2.com'}
       @fake_project_2 ={:name => 'second project from this organization', :ID =>'orgID2', :url => 'www.foo2.com'}
       @fake_project_list = [@fake_project_1, @fake_project_2]
       @fake_current_projects = 2
       @fake_past_projects = 3
        @fake_total_projects = @fake_current_projects + @fake_past_projects
       @fake_sector_distribution = [12, 0, 0, 0, 0, 0, 84, 4] 
  end
  
  def new_project
  redirect_to '/project_form' 
  end
  
   def download
    send_file '#{RAILS_ROOT}/images/bg.gif', :type => "image/gif"
    redirect_to  '/dashboard'
   end
   
   def delete
     
   redirect_to  '/dashboard'
   end
end
