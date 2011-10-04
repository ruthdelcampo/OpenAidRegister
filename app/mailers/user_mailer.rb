class UserMailer < ActionMailer::Base
  default :from => "contact@openaidregister.org"
  
  
  def welcome_email(user)
      @new_user = user
      
      mail(:to => user.email, :bcc => "ruthdelcampo@openaidregister.org", :subject => "Welcome to Open Aid Register!", :from => "signup@openaidregister.org")
    end
    
    
    def password_reset(random_token, email)
      @instance_token = random_token
        mail(:to => email, :subject => "Password Reset", :bcc =>"ruthdelcampo@openaidregister.org")
        
    end 
end
