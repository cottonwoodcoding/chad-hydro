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

  def newsletter
  end

  def send_newsletter
    begin
      profiles = Profile.where(newsletter: 1)
      if profiles.blank?
        flash[:alert] = "Nobody has subscribed to the newsletter."
      else
        NewsletterMailer.newsletter_email(profiles, params[:newsletter_content].html_safe).deliver
        flash[:notice] = "Newsletter Sent Successfully"
      end
    rescue => e
      flash[:alert] = 'There was an error sending the newsletter please try again'
    end
    redirect_to action: :newsletter
  end

  private

  def authenticate_admin!
    unless admin?
      flash[:alert] = "You must be the admin to do that action!"
      redirect_to controller: :about, action: :index
    end
  end

end
