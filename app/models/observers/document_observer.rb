class DocumentObserver < ActiveRecord::Observer
  def before_create(document)
    claim = document.claim
    changes = "A new document has been uploaded."
    
    if document.claim.present? && claim.point_person.present?
      UserMailer.notify_point_person(claim, changes).deliver_later
    end
  end
end
