class ContactController < ApplicationController
  respond_to :html

  def index
    f = Biggs::Formatter.new
    @address = f.format("us", # <= ISO alpha 2 code
      :street     => Setting.setting_value('general-street-address'),
      :city       => Setting.setting_value('general-city'),
      :zip        => Setting.setting_value('general-zip'),
      :state      => Setting.setting_value('general-state') # <= state/province/region
    )
    @days = %w(monday tuesday wednesday thursday friday saturday sunday)
  end

  def send_feedback
    begin
      FeedbackMailer.send_feedback(params[:email], params[:name], params[:message]).deliver
      flash[:notice] = "Feedback Sent Successfully"
    rescue => e
      flash[:alert] = 'There was an error sending your feedback please try again.'
    end
    redirect_to action: :index
  end

end
