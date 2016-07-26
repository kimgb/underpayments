class ClaimObserver < ActiveRecord::Observer
  def after_save(claim)
    changes = claim.changes.map do |attr, (old_val, new_val)|
      "#{attr} changed from #{old_val.nil? ? "nil" : old_val} to #{new_val}"
    end.join("\n\n")
    
    UserMailer.notify_point_person(claim, changes).deliver_later if claim.changed?
  end
end
