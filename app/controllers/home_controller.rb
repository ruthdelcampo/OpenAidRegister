class HomeController < ApplicationController
  
  def show
    
     if session[:organization]
        redirect_to '/dashboard'       
        return 
      end
    
  end
  
  
end
