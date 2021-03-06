class UserMailer < ActionMailer::Base
  helper AddressesHelper
  default from: 'no-reply@fairpay.org.au'

  def file_letter(sender, letter)
    @letter = letter
    user = letter.claim.user
    member_id = NUW::Person.get(email: user.email).try(:external_id)

    mail  to:         "feed@nuw.org.au",
          subject:    "done: letter_of_demand Letter of demand on behalf of #{member_id} #{user.proper_full_name}",
          from:       sender
  end

  # Email delivered to claimant from template at certain milestones.
  # TODO: send with token.
  def notify_stage_change(claim)
    @claim = claim

    mail  to:         @claim.user.email,
          subject:    "An update on your backpay claim",
          from:       @claim.point_person_email || "no-reply@fairpay.org.au",
          body:       "See an explanation of where we're at: #{@claim.stage.notification_text}"
  end

  # Point person or sysadmin is notified when a new claim is submitted and locked.
  def submission_email(claim)
    @claim = claim

    mail  to:         (@claim.point_person_email || "kbuckley@nuw.org.au"),
          subject:    "An underpayment claim has been submitted by #{@claim.user.email}"
  end

  # On new claim creation. Used to fire off an email to tgunstone and tsayers
  # when new users are created in the charity fundraising campaign.
  def new_claim(claim, recipients)
    @claim = claim

    mail  to:         recipients,
          subject:    "A new underpayment claim!"
  end

  # Point person is notified whenever a claim is updated.
  def notify_point_person(claim, changes)
    @claim, @changes = claim, changes

    mail  to:         (@claim.point_person_email || "kbuckley@nuw.org.au"),
          subject:    "Breaking news about #{@claim.user.email}'s underpayment claim!"
  end

  # If a user submits the "send feedback" form. Sent to sysadmin.
  def feedback_email(feedback)
    mail  to:         "kbuckley@nuw.org.au",
          subject:    "Feedback received from #{feedback['sender']}",
          from:       "#{feedback['sender']}",
          body:       feedback['body']
  end

  # Not enabled - an email on user signup.
  # def welcome_email(user)
  #   @user = user
  #
  #   mail  to:         @user.email,
  #         subject:    "You're on your way to getting your lost wages back"
  # end

  # Blank slate emails, used when an admin sends email to a claimant from the app.
  def generic_email_with_token(recipient, sender, subject, body, atts = [])
    # atts.each do |att|
    #   attachments[att[:filename]] = File.read(att[:tempfile])
    # end
    #
    mail  to:         recipient,
          from:       sender,
          subject:    subject,
          body:       body
  end
end
