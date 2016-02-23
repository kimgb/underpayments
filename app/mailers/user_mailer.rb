class UserMailer < ActionMailer::Base
  default from: 'no-reply@mg.nuw.org.au'
  
  def submission_email
    mail to:      "kbuckley@nuw.org.au",
         subject: "New underpayments submission",
         body:    "Please check the underpayments review queue for details."
  end
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "You're on your way to getting your lost wages back")
  end

  def generic_email_with_token(recipient, sender, message)
    mail to:      recipient.email,
         from:    sender.email,
         subject: message.subject,
         body:    message.body
  end
end
