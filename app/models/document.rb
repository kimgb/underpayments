class Document < ActiveRecord::Base
  belongs_to :claim

  mount_uploader :file, DocumentUploader
end
