class DeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  
  def invitation_instructions(record, token, opts={})
    @inviter = record.invited_by
    
    opts[:subject] = I18n.t("devise.mailer.invitation_instructions.subject")
    opts[:from] = "#{@inviter.full_name} <#{@inviter.email}>"
    opts[:reply_to] = opts[:from]
    headers[:bcc] = @inviter.email
    super
  end
end
