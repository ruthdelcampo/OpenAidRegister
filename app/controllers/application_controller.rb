class ApplicationController < ActionController::Base
 #rescue_from CartoDB::Client::Error :with => :deny_access
  
  protect_from_forgery
  
  #protected
  #def deny_access
  #debugger  
  #end 
  
  def show
    
  end
  
end
