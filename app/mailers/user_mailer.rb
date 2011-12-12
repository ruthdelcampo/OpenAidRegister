class UserMailer < ActionMailer::Base
  default :from => "contact@openaidregister.org"
  
  def welcome_email(user)
      @new_user = user
      mail(:to => user.email, :bcc => "ruthdelcampo@openaidregister.org", :subject => "Welcome to Open Aid Register!", :from => "signup@openaidregister.org")
    end
    
  #Not used in the current version  
  def password_reset(random_token, email)
      @instance_token = random_token
        mail(:to => email, :subject => "Password Reset", :bcc =>"ruthdelcampo@openaidregister.org")      
  end
  
  def errors_cartodb
    @new_user = user
      mail(:to => "ruthdelcampo@openaidregister.org", :subject => "Errors in Cartodb", :from => "contact@openaidregister.org")
  end 
  
  def new_file(user,filename)   
     @new_user = user
     @new_user[:filename] = filename
      mail(:to => "ruthdelcampo@openaidregister.org", :subject => "New File", :from => "contact@openaidregister.org")
  end
  

end
