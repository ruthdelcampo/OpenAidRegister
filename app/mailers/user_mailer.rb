class UserMailer < ActionMailer::Base
  default :from => "ruthdelcampo@gmail.com"
  
  
  def welcome_email(user)
      mail(:to => user.email, :subject => "Welcome to My Awesome Site")
    end
    
    
    def password_reset(random_token, email)
      @instance_token = random_token
        mail(:to => email, :subject => "Password Reset")
        
    end 
end
