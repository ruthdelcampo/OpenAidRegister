# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OpenAidRegister::Application.initialize!

#Configure mailing system
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => "openaidregister.org",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}