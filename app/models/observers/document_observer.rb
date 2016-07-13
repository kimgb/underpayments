class DocumentObserver < ActiveRecord::Observer
  observe :document

  def after_create(document)
    changes = "A new document was uploaded!"

    UserMailer.notify_point_person(document.claim, changes).deliver_later if document.claim_id?
  end
end
