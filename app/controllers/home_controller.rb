class HomeController < ApplicationController
  
  def show
    
     if session[:organization]
        redirect_to '/dashboard'       
        return 
      end
       
       #we will need to select the ones which its organizations are validated
       
       
      
       
        #sql = "select * from projects WHERE organization_id IN (select cartodb_id from organizations WHERE is_validated = true) ORDER BY updated_at DESC LIMIT 3"
        #result =  CartoDB::Connection.query(sql)
        #@latest_published = result.rows
    
  end
  
  
end
