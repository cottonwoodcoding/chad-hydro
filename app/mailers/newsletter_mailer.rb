class NewsletterMailer < ActionMailer::Base
  include SendGrid

  default from: "newsletter@moonlightgardensupply.com"

  def newsletter_email(profiles, content)
    emails = profiles.map{|profile| profile.user.email}.join(',')
    @content = content
    mail(:to => emails, :subject => "Moonlight Newsletter")
  end
end
