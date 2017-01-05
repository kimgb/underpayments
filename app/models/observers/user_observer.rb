class UserObserver < ActiveRecord::Observer
  def after_create(user)
    if user.group.slug == "face-to-face-fundraising" && user.claim.present?
      UserMailer.new_claim(user.claim, ENV["f2f_notification_emails"].split(",")).deliver_later
    end
  end
end
