class HomeController < ApplicationController
  
  
  def show
    
     if session[:organization]
        redirect_to '/dashboard'       
        return 
      end
       
       #we will need to select the ones which its organizations are validated
       
        sql = "SELECT p.cartodb_id,p.title,p.description, o.organization_name,p.budget,p.start_date,p.end_date
                FROM projects as p inner join organizations as o on p.organization_id=o.cartodb_id
                WHERE o.is_validated = true
                ORDER BY p.updated_at DESC LIMIT 2"
        
        result =  CartoDB::Connection.query(sql)
        
      
        @latest_published = result.rows
          
    
  end
  
  
  
  
end
