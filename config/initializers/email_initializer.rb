if Rails.env == 'development'
  begin
    email_config = YAML.load_file('config/email.yml')
    ENV['sendgrid_username'] = email_config['sendgrid_username']
    ENV['sendgrid_password'] = email_config['sendgrid_password']
  rescue
    raise "email.yml not found in the config dir."
  end
end