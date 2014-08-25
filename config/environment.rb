# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
ChadHydro::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => 25,
  :domain => "cottonwoodcoding.com",
  :authentication => :plain,
  :user_name => ENV['sendgrid_username'],
  :password => ENV['sendgrid_password']
}

