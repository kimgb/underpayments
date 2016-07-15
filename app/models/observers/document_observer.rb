class DocumentObserver < ActiveRecord::Observer
  def before_create(document)
    if document.claim_id?
      claim = document.claim
      changes = "A new document has been uploaded."
    
      UserMailer.notify_point_person(claim, changes).deliver_later
    end
  end
end
