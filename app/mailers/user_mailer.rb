class UserMailer < ActionMailer::Base
  default from: 'no-reply@mg.nuw.org.au'

  def submission_email(claim)
    @claim = claim

    mail  to:       (@claim.point_person_email || "kbuckley@nuw.org.au"),
          subject:  "An underpayment claim has been submitted by #{@claim.user.email}"
  end

  def new_claim(claim, recipients)
    @claim = claim

    mail  to:       recipients,
          subject:  "A new underpayment claim!"
  end

  def notify_point_person(claim, changes)
    @claim, @changes = claim, changes

    if @claim.point_person.present?
      mail  to:       (@claim.point_person_email || "kbuckley@nuw.org.au"),
            subject:  "Breaking news about #{@claim.user.email}'s underpayment claim!"
    end
  end

  def feedback_email(sender, body)
    mail  to:         "kbuckley@nuw.org.au",
          subject:    "Feedback received from #{sender}",
          from:       "#{sender}",
          body:       body
  end

  def welcome_email(user)
    @user = user

    mail  to:       @user.email,
          subject:  "You're on your way to getting your lost wages back"
  end

  def generic_email_with_token(recipient, sender, subject, body)
    mail  to:      recipient,
          from:    sender,
          subject: subject,
          body:    body
  end
end
