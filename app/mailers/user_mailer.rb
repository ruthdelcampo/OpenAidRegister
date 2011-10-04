class UserMailer < ActionMailer::Base
  default :from => "ruthdelcampo@openaidregister.org"
  
  
  def welcome_email(user)
      @new_user = user
      debugger
      mail(:to => user.email, :subject => "Welcome to Open Aid Register!")
    end
    
    
    def password_reset(random_token, email)
      @instance_token = random_token
        mail(:to => email, :subject => "Password Reset")
        
    end 
end
