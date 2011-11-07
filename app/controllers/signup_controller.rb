class SignupController < ApplicationController

  def signup
    #We need to initialize the hash
    @org_data = {}

     if !session[:organization].blank?
        sql="SELECT contact_name, email, telephone, organization_name, organization_country,
         organization_type_id, organization_guid, organization_web, api_key, package_name FROM organizations WHERE cartodb_id = ?"
         result = execute_query(sql, session[:organization][:cartodb_id])

         @org_data = result.rows.first
     end

  end

  def signup_validation

      #We need to initialize the hash
      @errors = []
      @org_data = params

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

       #if params[:telephone].length < 4
        #   @errors.push("Your telephone is empty or too short")
       # end

       #Organization length Validation.
       if params[:organization_name].empty?
         @errors.push("Your organization's name is empty")
       elsif params[:organization_name].length < 3
         @errors.push("The organization name should be longer than 2 characters")
       end


       #Organization's type Validation.
       if params[:organization_type_id].eql?("")
         @errors.push("Please select your organization's type")
       end

       #Organization's country Validation.
       if params[:organization_country].eql?("")
         @errors.push("Please select your organization's country")
       end
       
       #prepare organization guid to scape all whitespaces
       if params[:organization_guid].present?
          params[:organization_guid] = params[:organization_guid].tr(" ", "-")
      end
      
      
    if !session[:organization].blank?

        if @errors.count==0
          #no errors, save the data and redirect to singup_complete
          sql="UPDATE  organizations SET organization_guid ='?',
          password = md5('?'), contact_name= '?', telephone = '?',
          organization_name = '?', organization_type_id ='?',
          organization_country = '?', organization_web ='?',
          api_key = '?', package_name = '?'
          where cartodb_id = ?"
          execute_query(sql, params[:organization_guid],
                             params[:password],
                             params[:contact_name],
                             params[:telephone],
                             params[:organization_name],
                             params[:organization_type_id],
                             params[:organization_country],
                             params[:organization_web],
                             params[:api_key],
                             params[:package_name],
                             session[:organization][:cartodb_id])

          #update the session info
          sql="SELECT cartodb_id, contact_name, email, telephone, organization_name, organization_country,
          organization_type_id, organization_guid, organization_web, api_key, package_name
          FROM organizations WHERE cartodb_id = ?"
          result = execute_query(sql, session[:organization][:cartodb_id])
          session[:organization] = result.rows.first

            redirect_to '/dashboard',  :notice => "Your account has been succesfully updated"
        else
          @org_data[:email] = session[:organization][:email]
          #there has been errors print them on the template
          render :template => 'signup/signup'
        end
      else
      #email Validation. First checks if its empty and then checks if it already exists or if it has the right format
      String format_email = (/^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i)
      if params[:email].blank?
        @errors.push("The email is empty")
      else
        if already_exists(params[:email])
         @errors.push("This email already exists")
        elsif !match_email(params[:email])
          @errors.push("The format of the email is wrong")
        end
      end

        if params[:conditions].blank?
          @errors.push("Please accept the conditions and terms")
        end
        if @errors.count==0
            #no errors, save the data and redirect to singup_complete
             #save to CartoDB. Is Validated must be false
              sql="INSERT INTO organizations(organization_guid, email, password, contact_name, telephone, organization_name,
              organization_type_id, organization_country, organization_web, is_validated)
              VALUES('?','?',md5('?'),'?','?',
              '?','?',
              '?','?', 'false')"
              execute_query(sql, params[:organization_guid],
                                 params[:email],
                                 params[:password],
                                 params[:contact_name],
                                 params[:telephone],
                                 params[:organization_name],
                                 params[:organization_type_id],
                                 params[:organization_country],
                                 params[:organization_web])

              #login the user
              sql="SELECT cartodb_id, contact_name, email, telephone, organization_name, organization_country,
              organization_type_id, organization_guid, organization_web
              FROM organizations WHERE email='?'"
              result = execute_query(sql, quote_string(params[:email]))
              session[:organization] = result.rows.first

              #send an email
              UserMailer.welcome_email(session[:organization]).deliver
              redirect_to :action => :signup_complete
        else
              #there has been errors print them on the template
              render :template => 'signup/signup'
        end
    end

end

  def signup_complete

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

    sql="SELECT cartodb_id, contact_name, email, telephone, organization_name, organization_country,
    organization_type_id, organization_guid, organization_web FROM organizations WHERE email='?' AND password=md5('?')"
    result = execute_query(sql, quote_string(params[:email]), quote_string(params[:password]))

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

  def already_exists (email)
     sql="SELECT cartodb_id FROM organizations WHERE email='?'"
      result = execute_query(sql, email)
      if result.rows.length==0
        return false
      else
        return true
      end
  end

  #Not used in the current version
  def forgot_password

    if params[:method]=="post"
      @errors = Array.new
      #email Validation. First checks if its empty and then checks if it has the right format
      if params[:email].blank?
        @errors.push("The email is empty")
      elsif !match_email(params[:email])
        @errors.push("The format of the email is wrong")
      end
      
      if @errors.count==0
        random_token = SecureRandom.urlsafe_base64
        sql="UPDATE organizations SET random_token ='?' WHERE organizations.email = '?'"
        execute_query(sql, random_token, params[:email])
        UserMailer.password_reset(random_token, params[:email]).deliver
        redirect_to '/', :alert => "Email sent with  password reset instructions."
        return
      else
      render :template => 'signup/forgot_password'
      end
    end

  end

  #not used in the current session
  def logout
    reset_session
    redirect_to '/'
    return
  end
  
  
  #Not used in the current session
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
          sql="UPDATE organizations SET password ='?', random_token = null WHERE organizations.random_token = '?'"
          result = execute_query(sql, params[:password], params[:token])
          redirect_to '/login', :alert => "you can now login"
        end
    else
    sql="select email FROM organizations WHERE random_token = '?'"
    result = execute_query(sql, params[:id])
      if result.rows.length==0
      redirect_to '/forgot_password', :alert => "unknown one time password"
      else
        @user_password_reset = result.rows.first[:email]
      render :template => 'signup/password_reset'
      end
    end
  end

end
