class DeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  
  def invitation_instructions(record, token, opts={})
    opts[:subject] = I18n.t("devise.mailer.invitation_instructions.subject")
    opts[:from] = "#{record.invited_by.full_name} <#{record.invited_by.email}>"
    opts[:reply_to] = opts[:from]
    headers[:bcc] = record.invited_by.email
    super
  end
end
