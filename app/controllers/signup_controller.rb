class SignupController < ApplicationController
  
  def signup          
    
  end
  
  def signup_validation
    
    @errors = Array.new
    
    #email Validation. First checks if its empty and then checks if it already exists or if it has the right format
    String format_email = (/^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i)
    if params[:email].blank?
      @errors.push("The email is empty")
    else
      if already_exists(params[:email])
       @errors.push("This email already exists")
       end
            
      unless params[:email].match(format_email)
      @errors.push("The format of the email is wrong")
      end
    end
    
    #password length Validation. 
    if params[:password].empty?
       @errors.push("Password is empty")
    elsif params[:password].length < 3
      @errors.push("Insufficient password's length")
    end
    #password_confirm Validation. 
    if params[:password_confirm].empty?
       @errors.push("You need to repeat the password")
    else 
      unless params[:password_confirm].eql?(params[:password])
      @errors.push("Password's don't match")
      end
    end
    
    #Name length Validation. 
    if params[:contact_name].empty?
      @errors.push("Your name is empty")
    elsif params[:contact_name].length < 3
      @errors.push("Please enter name and surname. It should be longer than 2 characters")
    end
    
    #Phone Validation. 
   
    if params[:telephone].length < 4
        @errors.push("Your telephone is empty or too short")
    end
    
    #Organization length Validation. 
    if params[:organization_name].empty?
      @errors.push("Your organization is empty")
    elsif params[:organization_name].length < 3
      @errors.push("The organization name should be longer than 2 characters")
    end
    
    
    #Organization's type Validation. 
    if params[:organization_type_id].eql?("")
      
      @errors.push("Please select your organization's type")
    end
    
    #Organization's country Validation. 
    if params[:organization_country].eql?("1")
      
      @errors.push("Please select your organization's country")
    end
    
    if params[:conditions].blank?
      @errors.push("Please accept the conditions and terms")
    end
    
    
    if @errors.count==0
      #no errors, save the data and redirect to singup_complete
      
      
      #save to CartoDB. Is Validated will be false
      sql="INSERT INTO organizations(organization_guid, email, password, contact_name, organization_name, 
      organization_type_id, organization_country, organization_web, is_validated) 
      VALUES('#{params[:organization_guid]}','#{params[:email]}','#{params[:password]}','#{params[:contact_name]}',
      '#{params[:organization_name]}',#{params[:organization_type_id]},
      '#{params[:organization_country]}','#{params[:organization_web]}', 'false')"
      CartoDB::Connection.query(sql)
      
      sql="SELECT * FROM organizations WHERE email='#{quote_string(params[:email])}' AND password='#{quote_string(params[:password])}'"
      result = CartoDB::Connection.query(sql)
      session[:organization] = result.rows.first
      
      UserMailer.welcome_email(session[:organization]).deliver
      
      redirect_to :action => :signup_complete
    else
      #there has been errors print them on the template
      render :template => 'signup/signup'
    end
    
  end
  
  def signup_complete
    
    debugger
    if session[:organization]
    else
       redirect_to '/login'       
       return
     end
  end
  
  def login
    
    if session[:organization]
      redirect_to '/dashboard'       
      return 
    end
  end
  
  def login_validation
    
    
    
    sql="SELECT * FROM organizations WHERE email='#{quote_string(params[:email])}' AND password='#{quote_string(params[:password])}'"
    result = CartoDB::Connection.query(sql)
    
    if result.rows.length==0
      @errors = Array.new
      @errors.push("Login incorrect")
      render :template => 'signup/login'
    else
      session[:organization] = result.rows.first
      redirect_to session[:return_to] || request.referer
      #redirect_to(:back)
      #redirect_to '/dashboard'
    end
    
    
      
     
  end
  
  def forgot_password
    
    if params[:method]=="post"
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
      if @errors.count==0
        
        # send an email thanks for submitting
        #UPDATE table_name SET column1=value, column2=value2,... WHERE some_column=some_value
        random_token = SecureRandom.urlsafe_base64  
        
        sql="UPDATE organizations SET random_token ='#{random_token}' WHERE organizations.email = '#{params[:email]}'"
        CartoDB::Connection.query(sql)
        
        UserMailer.password_reset(random_token, params[:email]).deliver
        
        #mail_to params[:email], :bcc => "ruthdelcampo@gmail.com", :subject => "Password reset", :body => "we just reset your password to xyza. Please go to your organizations website and change the details"
        
        
        redirect_to '/', :alert => "Email sent with  password reset instructions."
       
        return
        
      else
      render :template => 'signup/forgot_password'
      end
    end
      
  end
  
  
  def logout
    reset_session
    
    redirect_to '/'
    return 
  end
  
  
  def quote_string(v)
    v.to_s.gsub(/\\/, '\&\&').gsub(/'/, "''")
  end
  
  def password_reset
    
    @errors = Array.new
    if params[:method]=="post"
    #password length Validation. 
        if params[:password].empty?
           @errors.push("Password is empty")
        elsif params[:password].length < 3
          @errors.push("Insufficient password's length")
        end
        #password_confirm Validation. 
        if params[:password_confirm].empty?
           @errors.push("You need to repeat the password")
        else 
          unless params[:password_confirm].eql?(params[:password])
          @errors.push("Password's don't match")
          end
        end 
        
         if @errors.count==0
            #no errors, save the data and redirect to singup_complete
            
          sql="UPDATE organizations SET password ='#{params[:password]}', random_token = null WHERE organizations.random_token = '#{params[:token]}'"
          result = CartoDB::Connection.query(sql)
          redirect_to '/login', :alert => "you can now login"
        end
      
    else
      
    sql="select * FROM organizations WHERE random_token = '#{params[:id]}'"
    result = CartoDB::Connection.query(sql) 
      if result.rows.length==0
      redirect_to '/forgot_password', :alert => "unknown one time password"
      else
        @user_password_reset = result.rows.first[:email]
        
      render :template => 'signup/password_reset'
      end
    end
  end
  
  def already_exists (email)
     sql="SELECT * FROM organizations WHERE email='#{email}'"
      result = CartoDB::Connection.query(sql)

      if result.rows.length==0
        return false
      else
        return true
      end
    
  end
  
  
  
end
