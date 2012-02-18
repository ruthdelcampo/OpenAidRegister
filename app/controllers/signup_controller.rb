class SignupController < ApplicationController

  def signup
    # We need to initialize the hash
    @org_data = {}
    if !session[:organization].blank?
      @org_data = Organization.find(session[:organization][:cartodb_id])
    end
  end

  # TODO: THIS ACTION IS USED FOR CREATE AND UPDATE AN ORGANIZATION
  # SEPARATE EACH ACTION IN THEIR OWN METHODS AND URLS
  def signup_validation
    @org_data = params
    @errors = Organization.validate(params)

    # prepare organization guid to scape all whitespaces
    if params[:organization_guid].present?
      params[:organization_guid] = params[:organization_guid].tr(" ", "-")
    end

    if !session[:organization].blank?
      if @errors.count == 0
        # no errors, save the data and redirect to singup_complete
        Organization.update(session[:organization][:cartodb_id], params)
        # update the session info
        session[:organization] = Organization.find(session[:organization][:cartodb_id])
        redirect_to '/dashboard',  :notice => "Your account has been succesfully updated"
      else
        @org_data[:email] = session[:organization][:email]
        # there has been errors print them on the template
        render :template => 'signup/signup'
      end

    else
      # email Validation. First checks if its empty and then checks if it already exists or if it has the right format
      @errors = Organization.validate_email_and_conditions(params, @errors)

      if @errors.count==0
        # no errors, save the data and redirect to singup_complete
        # save to CartoDB. Is Validated must be false
        org = Organization.create(params)
        # login the user
        session[:organization] = org
        #we include the organization type by id
        session[:organization].organization_type_name =  organization_type_by_id(session[:organization].organization_type_id)
        #send an email
        UserMailer.welcome_email(session[:organization]).deliver
        redirect_to :action => :signup_complete
      else
        # there has been errors print them on the template
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
    organization = Organization.by_email_and_password(params[:email], params[:password])
    if organization
      session[:organization] = organization
      redirect_to session[:return_to] || request.referer
    else
      @errors = ["Login incorrect"]
      render :template => 'signup/login'
    end
  end


  # Not used in the current version
  def forgot_password
    if params[:method]=="post"
      @errors = Array.new
      #email Validation. First checks if its empty and then checks if it has the right format
      if params[:email].blank?
        @errors.push("The email is empty")
      elsif !Oar::match_email(params[:email])
        @errors.push("The format of the email is wrong")
      end

      if @errors.count==0
        random_token = SecureRandom.urlsafe_base64
        sql="UPDATE organizations SET random_token ='?' WHERE organizations.email = '?'"
        Oar::execute_query(sql, random_token, params[:email])
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
        result = Oar::execute_query(sql, params[:password], params[:token])
        redirect_to '/login', :alert => "you can now login"
      end
    else
      sql="select email FROM organizations WHERE random_token = '?'"
      result = Oar::execute_query(sql, params[:id])
      if result.rows.length==0
        redirect_to '/forgot_password', :alert => "unknown one time password"
      else
        @user_password_reset = result.rows.first[:email]
        render :template => 'signup/password_reset'
      end
    end
  end

private

  def organization_type_by_id(id)
    ORGANIZATION_TYPE_LIST.select{|organization_type| organization_type.last.to_i == id.to_i}.first.first if id.present?
  end

  def organization_type_by_name(name)
    ORGANIZATION_TYPE_LIST.select{|organization_type| organization_type.first == name}.first.last if name.present?
  end

end
