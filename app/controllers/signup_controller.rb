class SignupController < ApplicationController
  
  def signup          
    
  end
  
  def signup_validation
    
    @errors = Array.new
    
    #Validations
    if params[:email].blank?
      @errors.push("The email is empty")
    end 
    #other validations
    
    if @errors.count==0
      #no errors, save the data and redirect to singup_complete
      
      redirect_to :action => :signup_complete
    else
      #there has been errors print them on the template
      render :template => 'signup/signup'
    end
    
  end
  
  def signup_complete
  end
  
  def login
  end
  
  def forgot_password
  end
  
end
