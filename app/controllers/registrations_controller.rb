class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  def after_sign_up_path_for(resource)
    customer = ShopifyAPI::Customer.all(from: :search, params: {q: "email:#{resource.email}"})
    exists = customer.count == 1
    new_customer = ShopifyAPI::Customer.create(first_name: resource.first_name, last_name: resource.last_name, email: resource.email) unless exists
    if new_customer.nil?
      current_user.update_attributes!(shopify_customer_id: customer.first.id)
    else
      current_user.update_attributes!(shopify_customer_id: new_customer.id)
    end
    new_profile_path
  end
end
