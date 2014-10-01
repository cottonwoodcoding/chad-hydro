class FeedbackMailer < ActionMailer::Base
  include SendGrid

  default from: "feedback@moonlightgardensupply.com"

  def send_feedback(email, name, content)
    emails = ['jake@moonlightgardensupply.com', 'zach@moonlightgardensupply.com', 'chad@moonlightgardensupply.com']
    @email = email
    @name = name
    @content = content
    mail(:to => emails, :subject => "#{name} has a message for Moonlight Garden Supply")
  end
end