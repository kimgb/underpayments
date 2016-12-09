class ClaimObserver < ActiveRecord::Observer
  # Notify point person on changes
  def after_save(claim)
    # Special handling for claim_status_id, etc...
    changes = claim.changes.map do |attr, (old_val, new_val)|
      "#{attr} changed from #{old_val.nil? ? "nil" : old_val} to #{new_val}"
    end.join("\n\n")
    
    if claim.point_person_id? && claim.changed?
      UserMailer.notify_point_person(claim, changes).deliver_later
    end
  end
end
