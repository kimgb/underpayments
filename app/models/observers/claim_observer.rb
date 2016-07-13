class ClaimObserver < ActiveRecord::Observer
  observe :claim

  def before_save(claim)
    changes = claim.changes.map do |attr, (attr_from, attr_to)|
      "#{attr} changed from #{attr_from} to #{attr_to}"
    end.join("\n\n")

    UserMailer.notify_point_person(claim, changes).deliver_later if claim.changed?
  end
end
