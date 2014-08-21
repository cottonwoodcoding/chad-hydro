class AdminController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_admin!

  def settings
    @settings = Setting.all
  end

  def save_settings
    begin
    params['setting-name'].each do |key, value|
      Setting.find_by_name(key).update_attributes!(value: value)
    end
    flash[:notice] = "Settings updated successfully."
    rescue => e
       flash[:alert] = "Settings were not updated. Please make sure everything is filled out and try again."
    end
    redirect_to action: :settings
  end

  private

  def authenticate_admin!
    unless admin?
      flash[:alert] = "You must be the admin to do that action!"
      redirect_to controller: :about, action: :index
    end
  end

end
