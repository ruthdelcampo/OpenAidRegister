class SignupController < ApplicationController
  
  def signup          
    
  end
  
  def signup_validation
    
    @errors = Array.new
    
    #email Validation. First checks if its empty and then checks if it has the right format
    String format_email = (/^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i)
    if params[:email].blank?
      @errors.push("The email is empty")
    else 
      unless params[:email].match(format_email)
      @errors.push("The format of the email is wrong")
      end
    end
    
    #password length Validation. 
    if params[:password].empty?
       @errors.push("Password is empty")
    else params[:password].length < 3
      @errors.push("Insufficient password's length")
    end
    
    #Name length Validation. 
    if params[:name].empty?
      @errors.push("Your name is empty")
    else params[:name].length < 3
      @errors.push("Please enter name and surname. It should be longer than 2 characters")
    end
    
    #Position length Validation. 
    if params[:position].empty?
      @errors.push("Your position is empty")
    else params[:position].length < 3
      @errors.push("Insufficient length of your position")
    end
    
    #Phone Validation. 
    format_phone = (/^[+\/\-() 0-9]+$/)
    if params[:telephone].length < 4
        @errors.push("Your telephone is empty or too short")
    else
        unless 
         params[:telephone].match (format_phone) 
        @errors.push("Please enter a valid phone number")
        end
    end
    
    #Organization length Validation. 
    if params[:organization].empty?
      @errors.push("Your organization is empty")
    else params[:organization].length < 3
      @errors.push("The organization name should be longer than 2 characters")
    end
    
    #Organization's type Validation. 
    if params[:org_type].match("1")
      @errors.push("Please select your organization's type")
    end
    
    #Organization's country Validation. 
    if params[:org_country].match("1")
      @errors.push("Please select your organization's country")
    end
    
    if params[:conditions].blank?
      @errors.push("Please accept the conditions and terms")
    end
    
    if @errors.count==0
      #no errors, save the data and redirect to singup_complete
      
      
      #save to CartoDB
      sql="INSERT INTO organizations(organization_name) VALUES(#{params[:organization]})"
      CartoDB::Connection.query(sql)
      
      
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
  
  def login_validation
    
     @errors = Array.new
      #email validation
      if params[:email].blank?
        @errors.push("The email is empty")
      end
      
      #password length Validation. 
      if params[:password].blank?
         @errors.push("Password is empty")
      end
      
      if @errors.count==0
           #no errors, save the data and redirect to dashboard
      redirect_to '/dashboard'
      else
      #there has been errors print them on the template
        render :template => 'signup/login'
      end
     
  end
  
  def forgot_password
  end
  
end
