class UserMailer < ActionMailer::Base
  default from: 'no-reply@mg.nuw.org.au'
  
  def submission_email
    mail to:      "kbuckley@nuw.org.au",
         subject: "New underpayments submission",
         body:    "Please check the underpayments review queue for details."
  end
end
