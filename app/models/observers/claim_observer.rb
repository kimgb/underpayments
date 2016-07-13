class ClaimObserver < ActiveRecord::Observer
  observe :claim

  def before_save(claim)
    UserMailer.notify_point_person(claim, claim.changes).deliver_later if claim.changed?
  end
end
