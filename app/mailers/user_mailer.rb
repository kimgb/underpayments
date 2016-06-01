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

  def generic_email_with_token(recipient, sender, subject, body)
    mail to:      recipient,
         from:    sender,
         subject: subject,
         body:    body
  end
end
