class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :cart
  before_filter :media

  private

  def cart
    @cart = session[:cart] || session[:cart] = {}
  end

  def media
    @social_media_settings = Setting.where('name like ?', '%-social')
  end
end
