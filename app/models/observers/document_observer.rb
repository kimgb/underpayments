class DocumentObserver < ActiveRecord::Observer
  def before_create(document)
    claim = document.claim
    changes = "A new document has been uploaded."
  
    UserMailer.notify_point_person(claim, changes).deliver_later if document.claim_id?
  end
end
