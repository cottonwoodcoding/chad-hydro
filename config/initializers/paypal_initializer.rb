if Rails.env == 'development'
  begin
    paypal_file = YAML.load "#{Rails.root}/config/paypal.yml"
    paypal = YAML.load_file(paypal_file)
    paypal.each { |key, value| ENV[key] || ENV[key] = value.to_s }
  rescue
    raise 'There is no paypal config'
  end
end
